pushd $(dirname "$0")
if [ "$1" == "deploy-all" ]; then
    kubectl apply -f ./ovpn-data.yaml
    kubectl apply -f ./ovpn-configs.yaml
    kubectl apply -f ./ovpn-deployment.yaml
    kubectl apply -f ./ovpn-service.yaml
elif [ "$1" == "clean" ]; then
    kubectl delete -f ./ovpn-service.yaml
    kubectl delete -f ./ovpn-deployment.yaml
    kubectl delete -f ./ovpn-configs.yaml
    kubectl delete -f ./ovpn-data.yaml
fi
