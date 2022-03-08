#!/bin/bash

IMG='bomkvilt.openvpn:0.1.0'

LOCATION='europe-central2'
FORMAT='docker'
HOST="${LOCATION}-${FORMAT}.pkg.dev"

PROJ='openvpn-343517'
REPO='main-repo'

FULL_REPO="${HOST}/${PROJ}/${REPO}"

if [ "$1" == "image" ]; then
    ./server/control.sh ${@:2}

elif [ "$1" == "local-helm" ]; then
    ./helm/openvpn/control.sh deploy ${@:2}

elif [ "$1" == "helm" ]; then
    ./helm/openvpn/control.sh deploy ${@:2} --set repo_prefix=$FULL_REPO/
fi
