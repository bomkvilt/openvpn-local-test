#!/bin/bash

TAG='bomkvilt.openvpn:latest'

function do_build() {
    docker build -t $TAG .
}

function do_stop {
    docker rm $(docker stop $(docker ps -a -q --filter ancestor=$TAG --format="{{.ID}}"))
}

function do_deploy {
    docker run -t -d $@ $TAG
}


pushd $(dirname "$0")
if [ "$1" == "build" ]; then
    do_build
elif [ "$1" == "stop" ]; then
    do_stop
elif [ "$1" == "run" ]; then
    do_stop
    do_build
    do_deploy ${@:2}        \
        --name openvpn      \
        --cap-add=NET_ADMIN
else
    echo "unexpected command"
    exit 1
fi
