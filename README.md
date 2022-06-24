# Reverse tunnel operation

## Launch sshd

/usr/bin/sshd

## Set up SSH public key authentication

~/.ssh/authorized_keys

## Connect to remote host

ssh -v -N -T \
-o UserKnownHostsFile=/dev/null \
-o StrictHostKeyChecking=no \
-o ServerAliveInterval=30 \
-o ExitOnForwardFailure=yes \
-R 2222:localhost:22 \

user@remotehost

## Log in to remote host and connect to localhost at port 2222

ssh -p 2222 user@localhost

