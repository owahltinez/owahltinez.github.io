#!/bin/bash

# Defaults
IPINDEX=0
SHOWADDRS=0
INTERFACE=venet0

# Parse options
while getopts ":i:n:l:" opt; do
  case $opt in
    i) INTERFACE="$OPTARG"
    ;;
    n) IPINDEX=$(($OPTARG))
    ;;
    l) SHOWADDRS=1
    ;;
    \?) echo "Usage: switchip [-l] [-i <network interface>] [-n <1-based index of available addresses>]"; exit;
    ;;
  esac
done

# List out all available addresses
ALLADDR=`ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -v ^::1 | grep -v ^fe80`
ADDRCOUNT=`echo "$ALLADDR" | wc -l`

# Do we only need to list them?
if [ "$SHOWADDRS" -eq "1" ]; then
    echo "$ALLADDR"
    exit
fi

# Check for root permissions
if [[ $EUID > 0 ]]; then
    echo "This script should not be run using sudo or as the root user"
    exit 1
fi

# If index was not set, pick one at random
if (( IPINDEX < 1 )); then
    IPINDEX=`shuf -i 1-${ADDRCOUNT} -n 1`
fi

COUNTER=1
for ADDR in $ALLADDR; do
    if [ "$COUNTER" == "$IPINDEX" ]; then
	echo "Selecting IP address as default: $ADDR"
	FLAG=1
    else
	FLAG=0;
    fi
    ip addr change $ADDR dev $INTERFACE preferred_lft $FLAG
    COUNTER=$((COUNTER+1))
done;
