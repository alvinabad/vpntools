#!/bin/bash

if [ $# -eq 0 ]; then
    cat <<EOF
Usage:
    `basename $0` [ssh options] user@host
EOF
    exit 1
fi

abort() {
    echo "aborting..."
    exit 1
}

trap abort INT

set -x

ssh -v -N -T \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o ExitOnForwardFailure=yes \
-D 127.0.0.1:1080 $*
