#!/bin/sh
set -xe

export DEBIAN_FRONTEND=noninteractive
fakesudo apt-get update
fakesudo apt-get -yq --no-install-suggests --no-install-recommends \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" dist-upgrade
fakesudo apt-get -yq autoremove
dl https://gitlab.com/omtinez/initscripts/raw/master/linux/init.sh | sh