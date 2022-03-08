pushd $(dirname "$0")
if [ "$1" == "deploy-all" ]; then
    kubectl apply -f ./ovpn-data.yaml
    kubectl apply -f ./ovpn-configs.yaml
    kubectl apply -f ./ovpn-deployment.yaml
    kubectl apply -f ./ovpn-service.yaml
fi
