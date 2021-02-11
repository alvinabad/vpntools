#!/bin/bash

#-------------------------------------------------------------------------------
# Openconnect wrapper script
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage: `basename $0` [options] vpnhost

User must have sudo access if CSD is used.

options:
    -u username      vpn username
                     It will be prompted if not supplied
    -g N             Authgroup number, e.g. 1
                     It will be prompted if not supplied
    -b               Run in background
    -v               verbose display

Examples:
    `basename $0` vpnhost
    `basename $0` -u vpnuser -g 1 vpnhost
EOF
    exit 1
}

abort() {
    echo "ERROR: $@"
    exit 1
}

[ $# -ne 0 ] || usage

while getopts ":u:g:bv" opt; do
  case "$opt" in
    u)
        USERNAME_OPT="--user $OPTARG"
        ;;
    g)
        AUTHGROUP_OPT="--authgroup $OPTARG"
        ;;
    b)
        BACKGROUND_OPT="--background"
        ;;
    v)
        VERBOSE_OPT=-v
        ;;
    ?)
        usage
        ;;
  esac
done
shift "$(($OPTIND -1))"

CSD_HOSTNAME=$1

if [ -f "$HOME/.cisco/csd-wrapper.sh" ]; then
    # must not run as root
    [ `id -u` -ne 0 ] || abort "CSD is detected. Must run as regular user; password for sudo will be prompted."
else
   # must run as root
   [ `id -u` -eq 0 ] || abort "Must run as root"
fi

unset ALL_PROXY NO_PROXY
unset all_proxy no_proxy

#    --background \
#    --os=win \

CSD_HOSTNAME=$1

export CSD_HOSTNAME

SUDO_OPT=
if [ -f "$HOME/.cisco/csd-wrapper.sh" ]; then
    SUDO_OPT="sudo -E"
fi

$SUDO_OPT openconnect \
    $USERNAME_OPT \
    $AUTHGROUP_OPT \
    $VERBOSE_OPT \
    $BACKGROUND_OPT \
    --pid-file=/var/run/openconnect.pid \
    --csd-user=$USER \
    --csd-wrapper=$HOME/.cisco/csd-wrapper.sh \
    $CSD_HOSTNAME

# kill cscan is if session is not on background
[ -n "$BACKGROUND_OPT" ] || pkill cscan

if [ -z "$BACKGROUND_OPT" ]; then
    echo "Openconnect session has been terminated."
else
    # process is running in background
    # wait a while to allow openconnect to display connection details
    sleep 7

    echo
    echo "Openconnect is running in the background."

    PID=`cat /var/run/openconnect.pid 2>/dev/null`
    if [ -n "$PID" ]; then
        ps --noheaders -p $PID
        echo "To terminate, run: sudo kill -2 $PID"
    else
        pgrep -a openconnect
        echo "To terminate, sudo kill -2 this process."
    fi
fi
