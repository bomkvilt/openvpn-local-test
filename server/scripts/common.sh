#!/bin/bash

function datef() {
    date +"%Y-%m-%d %T"
}

function createConfig() {
    CLIENT_ID="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
    CLIENT_PATH="${APP_PERSIST}/clients/$CLIENT_ID"

    # >>
    # Writing new private key to ${APP_PKI}/private/client.key
    # Client sertificate ${APP_PKI}/issued/client.crt
    # CA is by the path ${APP_PKI}/ca.crt
    pushd "${APP_PERSIST}" &> /dev/null
    ${EASYRSA}/easyrsa build-client-full "$CLIENT_ID" nopass &> /dev/null
    popd &> /dev/null

    mkdir -p $CLIENT_PATH
    cp  "${APP_PKI}/private/$CLIENT_ID.key" \
        "${APP_PKI}/issued/$CLIENT_ID.crt"  \
        "${APP_PKI}/ca.crt"                 \
        $CLIENT_PATH

    # Set default value to HOST_ADDR if it was not set from environment
    if [ -z "$HOST_ADDR" ]; then
        HOST_ADDR='localhost'
    fi

    cp "${OVPN_CLIENT_CONFIG}" "${CLIENT_PATH}/client.ovpn"

    echo -e "\nremote $HOST_ADDR 1194" >> "$CLIENT_PATH/client.ovpn"

    # Embed client authentication files into config file
    cat <(echo -e '<ca>') \
        "$CLIENT_PATH/ca.crt" <(echo -e '</ca>\n<cert>') \
        "$CLIENT_PATH/$CLIENT_ID.crt" <(echo -e '</cert>\n<key>') \
        "$CLIENT_PATH/$CLIENT_ID.key" <(echo -e '</key>\n') \
        >> "${CLIENT_PATH}/client.ovpn"

    echo $CLIENT_PATH
}

function zipFiles() {
    CLIENT_PATH="$1"
    IS_QUITE="$2"

    # -q to silence zip output
    # -j junk directories
    zip -q -j "$CLIENT_PATH/client.zip" "$CLIENT_PATH/client.ovpn"
    if [ "$IS_QUITE" != "-q" ]
    then
       echo "$(datef) $CLIENT_PATH/client.zip file has been generated"
    fi
}

function zipFilesWithPassword() {
    CLIENT_PATH="$1"
    ZIP_PASSWORD="$2"
    IS_QUITE="$3"
    # -q to silence zip output
    # -j junk directories
    # -P pswd use standard encryption, password is pswd
    zip -q -j -P "$ZIP_PASSWORD" "$CLIENT_PATH/client.zip" "$CLIENT_PATH/client.ovpn"

    if [ "$IS_QUITE" != "-q" ]
    then
       echo "$(datef) $CLIENT_PATH/client.zip with password protection has been generated"
    fi
}
