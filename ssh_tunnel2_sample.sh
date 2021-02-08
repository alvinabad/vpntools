#!/bin/bash

# create lookback on MacOS
# ifconfig lo0 alias 127.0.0.2
# to delete
# ifconfig lo0 -alias 127.0.0.2

# https://127.0.0.1:9443 -> host1 -> host2 -> https://host3

ssh -t -L 127.0.0.1:9443:127.0.0.1:9443 user@host1 \
    ssh -t -L 127.0.0.1:9443:host3:443 -N user@host2
