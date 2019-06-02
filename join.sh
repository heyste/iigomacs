#!/usr/bin/env bash

echo "Join iigomacs..."
if  docker ps | grep iigomacs > /dev/null ; then
  echo "Connecting to iigomacs..."
  CURRENT_ID=$(id -u):$(id -g)
  docker exec -it -u $CURRENT_ID iigomacs_iigomacs_1 /bin/bash -c "cd ~ && /bin/bash"
else
 echo "iigomacs not running. Start with './boot.sh'"
fi
