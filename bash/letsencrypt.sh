#!/bin/sh

# Ensure required directories exist
mkdir -p /tmp/www
mkdir -p /tmp/certs
mkdir -p /etc/nginx/ssl

# Create a strong DH key if none exist
DHPEM="/etc/nginx/ssl/dhparam.pem"
[ -e $DHPEM ] || openssl dhparam -out $DHPEM 2048

# Issue the certificates
/usr/local/bin/acme --issue \
    -w /tmp/www --certhome /tmp/certs $@

# Copy the created certificates, cleanup and exit
find /tmp/certs -name fullchain.cer -exec cp {} /etc/nginx/ssl/fullchain.cer \;
find /tmp/certs -name *.key -exec cp {} /etc/nginx/ssl/priv.key \;
rm -rf /tmp/www
rm -rf /tmp/certs
