FROM ubuntu:19.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update &&\
    apt-get upgrade -y 
RUN apt-get install -y software-properties-common \
                       git \
                       iputils-ping \
                       curl \
                       locales \ 
                       tmate \
                       xclip

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN git clone https://github.com/udhos/update-golang &&\
    cd update-golang &&\
    ./update-golang.sh

ENV GOROOT=/usr/local/go
RUN mkdir -p /user/go/src && mkdir -p /user/go/bin

RUN apt-get install -y emacs

RUN groupadd emacs &&\
    useradd -g emacs -d /user -s /sbin/bin -c "emacs" emacs

ENV PATH=$PATH:$GOROOT/bin
ENV GOPATH=/user/go

RUN git clone --depth 1 --recurse-submodules \
        https://github.com/iimacs/site-lisp \
        /usr/local/share/emacs/site-lisp

RUN emacs --batch -l /usr/local/share/emacs/site-lisp/default.el

RUN cd /tmp && curl -L -O https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb
RUN dpkg -i /tmp/pandoc-2.7.2-1-amd64.deb

RUN rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["ping", "-i 2147482", "localhost"]
