# Local OpenVPN deployment test

This is a pet project that:
- dockerize an OpenVPN server with integrated CA
    - allow to launch the container locally
- integrates the containter to kubernetes
    - allow to launch the cluster locally
- deploy the cluster to google cloud platform


## Related links DRAFT

| what | note | url |
| :--- | :--- | :-- |
| if u dont't understant what happens | [ru] | https://www.youtube.com/watch?v=mVwT4FzvvKc&t=2885s |
| dicker 2-in-1: server + CA          |      | https://github.com/dockovpn/docker-openvpn |
| step-by-step doc from DO            |      | https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04 |
| step-by-step doc from OpenVPN       |      | https://openvpn.net/community-resources/how-to/ |
|                                     |      | https://openvpn.net/community-resources/setting-up-your-own-certificate-authority-ca/ |

## google coud deploy
|    |    |
|----|----|
| connect cluster | https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#generate_kubeconfig_entry |
| load image      | https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app |
