#!/bin/sh
if [[ $(id -u) = 0 ]] ; then
    eval $@
else
    sudo $@
fi
