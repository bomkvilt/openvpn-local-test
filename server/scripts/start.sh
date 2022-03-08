#!/bin/bash

SCRIPTS="$(dirname "$0")"
source $SCRIPTS/common.sh

# ------------------------------------------------
# configure ports
# ------------------------------------------------
# \todo why do I need all the redirectoins?

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    echo "$(datef) Creating tun/tap device."
    mknod /dev/net/tun c 10 200
fi

# Allow UDP traffic on port 1194.
iptables -A INPUT  -i eth0 -p udp -m state --state NEW,ESTABLISHED --dport 1194 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp -m state --state ESTABLISHED     --sport 1194 -j ACCEPT

# Allow traffic on the TUN interface.
iptables -A INPUT   -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A OUTPUT  -o tun0 -j ACCEPT

# Allow forwarding traffic only from the VPN.
iptables -A FORWARD -i tun0 -o eth0 -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

# ------------------------------------------------
# create a CA certificate on a first launch
# ------------------------------------------------

cd "${APP_PERSIST}"

LOCKFILE="${APP_PERSIST}/.initialized"
if [ ! -f $LOCKFILE ]; then
    # >>
    # DH parameters of size 2048 created at ${APP_PKI}/dh.pem
    ${EASYRSA}/easyrsa gen-dh

    # >>
    # CA creation complete and you may now import and sign cert requests.
    # Your new CA certificate file for publishing is at:
    # ${APP_PKI}/ca.crt
    # \note blank line
    ${EASYRSA}/easyrsa build-ca nopass << EOF

EOF

    # >>
    # Keypair and certificate request completed. Your files are:
    # req: ${APP_PKI}/reqs/server.req
    # key: ${APP_PKI}/private/server.key
    # \note blank line
    ${EASYRSA}/easyrsa gen-req server nopass << EOF

EOF

    # >>
    # Certificate created at: ${APP_PKI}/issued/server.crt
    ${EASYRSA}/easyrsa sign-req server server << EOF
yes
EOF

    # \note can cause a race
    # \note commit that all files are created
    touch $LOCKFILE
fi

# ------------------------------------------------
# 
# ------------------------------------------------

cp \
    "${APP_PKI}/dh.pem"             \
    "${APP_PKI}/ca.crt"             \
    "${APP_PKI}/issued/server.crt"  \
    "${APP_PKI}/private/server.key" \
    "${OPENVPN}"

# launch in a background
openvpn --config "${OVPN_SERVER_CONFIG}"
