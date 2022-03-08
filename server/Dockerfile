FROM alpine:latest

# install all needded packegs
# \todo do i really need all of the packages?
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/"   >> /etc/apk/repositories && \
    apk add --update            \
        bash                    \
        openvpn                 \
        dumb-init               \
        easy-rsa                \
        libintl                 \
        inotify-tools           \
        openvpn-auth-pam        \
        google-authenticator    \
        pamtester               \
        tree                    \
    && \
    apk add --virtual           \
        temppkg                 \
        gettext                 \
    && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst     && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apk del temppkg                                  && \
    rm -rf                      \
        /tmp/*                  \
        /var/tmp/*              \
        /var/cache/apk/*        \
        /var/cache/distfiles/*

# files from build tree are placed in a install directory
ENV APP_INSTALL "/opt/openvpn_inst"

# internal pathes
ENV EASYRSA "/usr/share/easy-rsa"

COPY configs/vars "${EASYRSA}/vars"
COPY scripts      "${APP_INSTALL}/scripts"

# data that must was generated must be stotred in a persistance directory
ENV APP_PERSIST "/opt/openvpn_data"
ENV APP_PKI     "${APP_PERSIST}/pki"

# RUN mkdir -p "${APP_PERSIST}" && \
#     cd "${APP_PERSIST}"       && \
#     ${EASYRSA}/easyrsa init-pki

# configuration files are placed in a /etc/
ENV OPENVPN            "/etc/openvpn"
ENV OVPN_SERVER_CONFIG "${OPENVPN}/server.conf"
ENV OVPN_CLIENT_CONFIG "${OPENVPN}/client.ovpn"

COPY configs/server.conf "${OVPN_SERVER_CONFIG}"
COPY configs/client.ovpn "${OVPN_CLIENT_CONFIG}"

# VOLUME ["${APP_PERSIST}"]

RUN find "${APP_INSTALL}/scripts/" -type f -iname "*.sh" -exec chmod +x {} \;

# open container ports
EXPOSE 1194/udp
EXPOSE 8080/tcp

# start a process that locks an executions
WORKDIR "${APP_INSTALL}/scripts"
ENTRYPOINT ["dumb-init", "--"]
CMD ["bash", "./start.sh"]
