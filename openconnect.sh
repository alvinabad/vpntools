#!/bin/bash

#-------------------------------------------------------------------------------
# Openconnect wrapper script
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage: `basename $0` vpnhost
EOF
    exit 1
}

[ $# -ne 0 ] || usage

if [ `id -u` -eq 0 ]; then
    echo "Run as regular user; password for sudo will be prompted."
    exit 1
fi

unset ALL_PROXY NO_PROXY
unset all_proxy no_proxy

#    --background \
#    --os=win \

CSD_HOSTNAME=$1

#set -x
export CSD_HOSTNAME

sudo -E openconnect \
    -v \
    --pid-file=/var/run/openconnect.pid \
    --csd-user=$USER \
    --csd-wrapper=$HOME/.cisco/csd-wrapper.sh \
    --authgroup=1 \
    $CSD_HOSTNAME

pkill cscan
echo "$0 terminated"
