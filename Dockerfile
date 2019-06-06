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
                       xclip \
                       tmux  \
                       net-tools \
                       less

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN cd /tmp &&\
    git clone https://github.com/udhos/update-golang &&\
    cd update-golang &&\
    ./update-golang.sh

RUN cd /tmp &&\
    curl -L -O https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb &&\
    dpkg -i /tmp/pandoc-2.7.2-1-amd64.deb

RUN apt-get install -y emacs

RUN git clone --depth 1 --recurse-submodules \
        https://github.com/iimacs/site-lisp \
        /usr/local/share/emacs/site-lisp

RUN emacs --batch -l /usr/local/share/emacs/site-lisp/default.el

RUN groupadd emacs &&\
    useradd -g emacs -d /home/emacs -s /bin/bash -c "emacs" emacs

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /home/emacs
COPY emacs /home/emacs/

ENV HOME=/home/emacs
ENV GOPATH=$HOME/go
ENV GOROOT=/usr/local/go
ENV GOBIN=$GOPATH/bin
ENV PATH=$PATH:$GOROOT/bin:$GOBIN

RUN chown -R emacs:emacs /home/emacs
USER emacs

RUN go get -u -v github.com/fatih/gomodifytags &&\
    go get -u -v github.com/godoctor/godoctor &&\
    go install github.com/godoctor/godoctor &&\
    go get -u github.com/golangci/golangci-lint/cmd/golangci-lint &&\
    go get -u -v github.com/mdempsky/gocode &&\
    go get -u -v github.com/rogpeppe/godef &&\
    go get -u -v golang.org/x/tools/cmd/guru &&\
    go get -u -v golang.org/x/tools/cmd/gorename &&\
    go get -u -v golang.org/x/tools/cmd/goimports &&\
    go get -u -v golang.org/x/tools/cmd/godoc &&\
    go get -u -v github.com/zmb3/gogetdoc &&\
    go get -u -v github.com/cweill/gotests &&\
    go get -u github.com/haya14busa/gopkgs/cmd/gopkgs &&\
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct &&\
    go get -u github.com/josharian/impl &&\
    go get -u github.com/motemen/gore/cmd/gore

ENTRYPOINT ["ping", "-i 2147482", "localhost"]
