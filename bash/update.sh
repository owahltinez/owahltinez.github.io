#!/bin/sh
set -xe

export DEBIAN_FRONTEND=noninteractive
APTGET="fakesudo apt-get -o Dpkg::Progress-Fancy="1""
$APTGET update
$APTGET \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    -yq --no-install-suggests --no-install-recommends dist-upgrade
$APTGET -yq autoremove
dl https://owahltinez.github.io/linux/init.sh | sh
