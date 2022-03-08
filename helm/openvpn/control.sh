pushd $(dirname "$0") >> /dev/null
PROJECT=$(basename "$(pwd)")
if   [ "$1" == "deploy"  ]; then helm upgrade --install ${PROJECT} ${@:2} .
elif [ "$1" == "dry-run" ]; then helm install --dry-run --debug ${PROJECT} ${@:2} .
elif [ "$1" == "clean"   ]; then helm delete ${PROJECT}
fi
