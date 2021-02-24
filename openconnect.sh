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
    -p protocol      specify protocol, e,g, gp for Global Protect
                     defaults to Cisco Anyconnect
    -b               Run in background
    -c               Use Cisco CSD wrapper
    -v               verbose display

Examples:
    `basename $0` vpnhost
    `basename $0` -u vpnuser -g 1 vpnhost
    `basename $0` -u vpnuser -p gp vpnhost
EOF
    exit 1
}

abort() {
    echo "ERROR: $@"
    exit 1
}

[ $# -ne 0 ] || usage

USERNAME_OPT=
AUTHGROUP_OPT=
BACKGROUND_OPT=
VERBOSE_OPT=
CSD_OPT=

while getopts ":u:g:p:bcv" opt; do
  case "$opt" in
    u)
        USERNAME_OPT="--user $OPTARG"
        ;;
    g)
        AUTHGROUP_OPT="--authgroup $OPTARG"
        ;;
    p)
        PROTOCOL_OPT="--protocol $OPTARG"
        ;;
    b)
        BACKGROUND_OPT="--background"
        ;;
    c)
        CSD_OPT="--csd-user=$USER --csd-wrapper=$HOME/.cisco/csd-wrapper.sh"
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
VPN_HOST=$1

if [ -n "$CSD_OPT" ]; then
    # CSD option is used; must not run as root
    [ `id -u` -ne 0 ] || abort "CSD is detected. Must run as regular user; password for sudo will be prompted."

    # check if wrapper is present
    [ -f "$HOME/.cisco/csd-wrapper.sh" ] || abort "csd-wrapper.sh not found"
else
   # must run as root
   [ `id -u` -eq 0 ] || abort "Must run as root"
fi

unset ALL_PROXY NO_PROXY
unset all_proxy no_proxy

SUDO_OPT=
if [ -n "$CSD_OPT" ]; then
    export CSD_HOSTNAME=$VPN_HOST
    SUDO_OPT="sudo -E"
fi

$SUDO_OPT openconnect \
    $USERNAME_OPT \
    $AUTHGROUP_OPT \
    $VERBOSE_OPT \
    $BACKGROUND_OPT \
    $CSD_OPT \
    $PROTOCOL_OPT \
    --pid-file=/var/run/openconnect.pid \
    $VPN_HOST

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
