#!/bin/bash

set -e -o pipefail

script_dir=$(dirname $0)
script_dir=$(cd "$script_dir" && pwd)

#cd "$script_dir"

usage() {
    cat <<EOF
Usage:
    `basename $0` [options] user@host

options:
    -R       Remote server; defaults to 2222:localhost:22
    -M       Use autossh and set monitoring port
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
while getopts ":R:M:v" opt
do
  case "$opt" in
    R)
        REMOTE_SERVER=$OPTARG
        ;;
    M)
        AUTOSSH_MONITOR=$OPTARG
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

if [ -f /bin/MobaGitEditor ];then
    PGREP_CMD="pgrep -lf sshd"
else
    PGREP_CMD="pgrep -a sshd"
fi

if $PGREP_CMD; then
    echo "Found sshd"
else
    echo "I don't see sshd running?"
    if [ -e /usr/sbin/sshd ]; then
        # cygwin
        echo "Run: /usr/sbin/sshd"
    elif [ -e /usr/bin/sshd ]; then
        # mobaterm
        echo "Run: /usr/bin/sshd -p 23"
    else
        echo -n "Run: "
        type -P sshd
    fi
    abort ""
fi

if [ "$VERBOSE" = "true" ]; then
    cat <<EOF
    ssh -N -t $VERBOSE_OPT \\
    -o UserKnownHostsFile=/dev/null \\
    -o StrictHostKeyChecking=no \\
    -o ServerAliveInterval=30 \\
    -o TCPKeepAlive=no \\
    -o ExitOnForwardFailure=yes \\
    -R $REMOTE_SERVER  \\
    $*
EOF
fi

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

#echo "-R $REMOTE_SERVER"
echo "$SSH_OPT -N -t $VERBOSE_OPT -R $REMOTE_SERVER $*"

$SSH_OPT -N -t $VERBOSE_OPT \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o TCPKeepAlive=no \
-o ExitOnForwardFailure=yes \
-R $REMOTE_SERVER \
$*

#-o TCPKeepAlive=no \
