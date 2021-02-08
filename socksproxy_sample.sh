#!/bin/bash

# 127.0.0.1:1080 -> host1

ssh -v -N -D 127.0.0.1:1080 user@host1
