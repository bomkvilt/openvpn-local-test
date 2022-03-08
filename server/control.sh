#!/bin/bash

function do_build() {
    docker build -t $IMG .
}

function do_stop {
    docker rm $(docker stop $(docker ps -a -q --filter ancestor=$IMG --format="{{.ID}}"))
}

function do_deploy {
    docker run -t -d $@ $IMG
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

elif [ "$1" == "gloud-auth" ]; then
    gcloud artifacts repositories create $REPO   \
        --repository-format=${FORMAT}            \
        --location=${LOCATION}                   \
        --description="docker images repository"
    
    gcloud auth configure-docker ${HOST}

elif [ "$1" == "gloud-push" ]; then
    do_build
    docker tag ${IMG} ${FULL_REPO}/${IMG}
    docker push ${FULL_REPO}/${IMG}

else
    echo "unexpected command"
    exit 1
fi
