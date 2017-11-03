#!/bin/sh

# Ensure required directories exist
mkdir -p /tmp/www
mkdir -p /tmp/certs
mkdir -p /etc/nginx/ssl

# Create a strong DH key if none exist
[ -e /tmp/echo ] || openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Issue the certificates
/bin/sh /home/omtinez/bin/acme.sh --issue \
    -d domain1.com -d domain2.com -d domain3.com \
    -w /tmp/www --certhome /tmp/certs $@

# Copy the created certificates, cleanup and exit
find /tmp/certs -name fullchain.cer -exec cp {} /etc/nginx/ssl/fullchain.cer \;
find /tmp/certs -name *.key -exec cp {} /etc/nginx/ssl/priv.key \;
rm -rf /tmp/www
rm -rf /tmp/certs
