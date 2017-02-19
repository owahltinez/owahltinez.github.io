#!/bin/sh

# Ensure required directories exist
mkdir -p /tmp/www
mkdir -p /tmp/certs
mkdir -p /etc/nginx/certs

# Issue the certificates
/bin/sh ~/bin/acme.sh --issue \
	-d domain1.com -d domain2.com -d domain3.com \
    -w /tmp/www --certhome /tmp/certs $@

# Copy the created certificates, cleanup and exit
find /tmp/certs -name fullchain.cer -exec cp {} /etc/nginx/certs/fullchain.cer \;
find /tmp/certs -name *.key -exec cp {} /etc/nginx/certs/priv.key \;
rm -rf /tmp/www
rm -rf /tmp/certs
