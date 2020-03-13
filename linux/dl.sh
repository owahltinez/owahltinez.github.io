#!/bin/sh
if command -v curl > /dev/null 2>&1
    then curl -sSL $@
else 
    alias wget -O - $@
fi