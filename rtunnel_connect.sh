#!/bin/bash

set -e -o pipefail

usage() {
    cat <<EOF
Usage:
    `basename $0` [options] user@host

options:
    -R       Remote server; defaults to 2222:localhost:22
    -v       verbose
EOF
    exit 1
}

abort() {
    echo "ERROR: $*" 1>&2
    exit 1
}

[ $# -ne 0 ] || usage

REMOTE_SERVER='2222:localhost:22'
while getopts ":R:v" opt
do
  case "$opt" in
    R)
        REMOTE_SERVER=$OPTARG
        ;;
    v)
        VERBOSE=true
        VERBOSE_OPT=-v
        ;;
    ?)
        usage
        ;;
  esac
done
shift "$(($OPTIND - 1))"

if ps -ef | grep sshd | grep -v grep; then
    true
else
    abort "I don't see sshd running?"
fi

if [ "$VERBOSE" = "true" ]; then
    cat <<EOF
    ssh -N -t $VERBOSE_OPT \\
    -o UserKnownHostsFile=/dev/null \\
    -o StrictHostKeyChecking=no \\
    -o ServerAliveInterval=30 \\
    -o ExitOnForwardFailure=yes \\
    -R $REMOTE_SERVER  \\
    $*
EOF
fi

ssh -N -t $VERBOSE_OPT \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o ExitOnForwardFailure=yes \
-R $REMOTE_SERVER \
$*

#-o TCPKeepAlive=no \
