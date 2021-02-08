#!/bin/bash

# create lookback on MacOS
# ifconfig lo0 alias 127.0.0.2
# to delete
# ifconfig lo0 -alias 127.0.0.2

# create ssh tunnel to RDP to a Windows server
# rdp://127.0.0.1 -> host1 -> rdp://winhost

ssh -t -L 127.0.0.1:3389:winhost:3389 -N user@host1
