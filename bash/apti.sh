#!/bin/sh
set -xe
fakesudo apt-get \
    -o Dpkg::Progress-Fancy="1" \
    -yq --no-install-suggests --no-install-recommends install $@
