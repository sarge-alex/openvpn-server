# Start from Alpine base image
FROM alpine
LABEL maintainer="Sarge <sarge-alex@github.com>"
LABEL version="0.0.1"

# Set the working directory to /opt/app
WORKDIR /opt/app

RUN apk --no-cache --no-progress upgrade \
 && apk --no-cache --no-progress add \
    bash \
    bind-tools \
    oath-toolkit-oathtool \
    curl ip6tables \
    iptables \
    openvpn \
    easy-rsa \
    openvpn-auth-ldap

#Install Latest RasyRSA Version
RUN chmod 755 /usr/share/easy-rsa/*

# Copy all files in the current directory to the /opt/app directory in the container
COPY bin /opt/app/bin
COPY docker-entrypoint.sh /opt/app/docker-entrypoint.sh
RUN mkdir -p /opt/app/clients \
    /opt/app/db \
    /opt/app/log \
    /opt/app/pki \
    /opt/app/staticclients \
    /opt/app/config

# Add the openssl-easyrsa.cnf file to the easy-rsa directory
ADD openssl-easyrsa.cnf /opt/app/easy-rsa/

# Make all files in the bin directory executable
RUN chmod +x bin/*; chmod +x docker-entrypoint.sh

# Expose the OpenVPN port (1194/udp)
EXPOSE 1194/udp

# Set the entrypoint to the docker-entrypoint.sh script, passing in the following arguments:
# $REQ_COUNTRY $REQ_PROVINCE $REQ_CITY $REQ_ORG $REQ_OU $REQ_CN
ENTRYPOINT ./docker-entrypoint.sh
