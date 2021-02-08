#!/bin/bash

# 127.0.0.1:1080 -> host1 -> host2

ssh -J user@host1 -N -D 127.0.0.1:1080 user@host2
