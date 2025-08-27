#!/bin/bash

usage() {
    cat <<EOF
Socks Proxy Connection
Use autossh of available
Usage:
    `basename $0` [ssh options] user@host

ssh options:
    -D [bind_address:]port    Defaults to 127.0.0.1:1080

Example:
    `basename $0` -D 127.0.0.1:1080 root@192.168.1.1

EOF
    exit 1
}

abort() {
    echo "aborting..."
    exit 1
}

[ $# -ne 0 ] || usage

BIND_ADDRESS=127.0.0.1:1080
while getopts ":D:M:vh" opt
do
  case "$opt" in
    D)
        BIND_ADDRESS=$OPTARG
        ;;
    M)
        AUTOSSH_MONITOR=$OPTARG
        ;;
    v)
        VERBOSE=true
        VERBOSE_OPT=-v
        ;;
    h)
        usage
        ;;
    ?)
        usage
        ;;
  esac
done
shift "$(($OPTIND - 1))"

trap abort INT

if [ -n "$AUTOSSH_MONITOR" ]; then
    SSH_OPT="autossh -M $AUTOSSH_MONITOR"
elif type -P autossh >/dev/null; then
    SSH_OPT="autossh -M 0"
else
    SSH_OPT="ssh"
fi

if [ "$VERBOSE" = "true" ]; then
    set -x
fi

echo "$SSH_OPT -D $BIND_ADDRESS $* ..."

$SSH_OPT $VERBOSE_OPT -N -T \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o ExitOnForwardFailure=yes \
-D "$BIND_ADDRESS" $*
