## Reverse Tunnel Connection

If you don't have SSH access to a remote host machine due to some firewall restriction, 
e.g., incoming SSH connections are not allowed, but the remote host can SSH to your
machine, you will still be able to SSH to that remote machine by setting up a reverse tunnel. 
The reverse tunnel works like you don't have access to the door of the castle, however, 
there is someone inside the castle that can open a tunnel for you and now you can enter.

In order to create this tunnel connection, you need someone from the remote machine to 
initiate an SSH connection into your machine using the -R option. Once that tunnel connection is 
up and running, you will then be able to SSH from your machine into the remote host.

Below are the steps to set up a reverse tunnel connection.

1. Run an sshd server on the remote host
```
/usr/sbin/sshd
```

2. From the remote host, ssh into your host using the -R option.
```
ssh -v -N -t \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=30 \
    -o ExitOnForwardFailure=yes \
    -R 2222:127.0.0.1:22 \
    user@remotehost
```

The IP address 127.0.0.1 and port 2222 will serve as the IP address and port number your ssh connection 
needs to use to connect to the remote host.

3. From your host, SSH into the IP address 127.0.0.1 and port 2222. This should now allow you 
to connect the remote host.
```
ssh -p 2222 user@127.0.0.1
```

## Using Jump Servers to connect to a remote host

If you don't have access to a host machine , e.g., there is a firewall blocking 
outgoing SSH connections, you can still connect by SSH into the remote host by 
using jumps servers, where those jump servers don't have restrictions. 

Use the -J option to specify the jump server.
```
ssh -J someuser@jumphost.localdomain user@destination_host.localdomain
```

You can chain several jump servers.
```
ssh -J someuser@jumphost1.localdomain,someuser@jumphost2.localdomain \
    user@destination_host.localdomain
```

You may use ~/.ssh/config to set those jump servers.
```
Host destination_host.localdomain
    ProxyJump someuser@jumphost.localdomain:22
```

The ~/.ssh/config is ideal for Git access where you don't have direct
ssh access to the Git server but you have some hosts that can. 
A good example is github.com.

There are two ways to define the jump servers in ~/.ssh/config:

* ProxyJump
* ProxyCommand

ProxyJump:
```
Host github.com
    User git
    ProxyJump someuser@jumphost.localdomain:22
```

ProxyCommand:
```
Host github.com
    User git
    IdentityFile ~/.ssh/github.pem
    ProxyCommand ssh -J someuser@jumphost.localdomain:22 -W %h:%p
```

You can chain jump servers.

```
Host github.com
    User git
    IdentityFile ~/.ssh/github.pem
    ProxyJump someuser@jumphost.localdomain:22,someuser2@jumphost2.localdomain:22
```

```
Host github.com
    User git
    IdentityFile ~/.ssh/github.pem
    ProxyCommand ssh -J someuser@jumphost.localdomain:22,someuser2@jumphost2.localdomain:22 -W %h:%p
```

If you are using SSH public key authentication, each jump server host must have 
~/.ssh/authorized_keys properly set.
