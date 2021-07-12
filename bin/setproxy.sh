#!/bin/bash

op=$1

if [ -z $op ]; then
    op="on"
fi

addr="192.168.2.5:8080"
etc_config=$HOME/.local/etc/config.sh

if [[ "$op" == "on" ]]; then
    sed -i 's/^export http_proxy=.*/export http_proxy=http:\/\/'$addr'/' $etc_config
    echo "set proxy $addr ok"
else
    sed -i 's/^export http_proxy=.*/export http_proxy=/' $etc_config
    echo "set proxy off ok"
fi

