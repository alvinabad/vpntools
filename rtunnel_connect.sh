#!/bin/bash

ENDPOINT=$1

if [ $# -eq 0 ]; then
    cat <<EOF
Usage:
    `basename $0` user@host
EOF
    exit 1
fi

abort() {
    echo "aborting..."
    exit 1
}

trap abort INT

#while :
#do
#echo "Restarting tunnel..."
#sleep 5
#done
#-R 3389:localhost:3389 \

#set -x

cat <<EOF
ssh -N -T \\
-o UserKnownHostsFile=/dev/null \\
-o StrictHostKeyChecking=no \\
-o ServerAliveInterval=30 \\
-o ExitOnForwardFailure=yes \\
-R 2222:localhost:22 \\
$*
EOF
#-o TCPKeepAlive=no \\

ssh -N -T \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o ExitOnForwardFailure=yes \
-R 2222:localhost:22 \
$*

#-o TCPKeepAlive=no \
