## Connect to a proxy server
```
ssh -v -N -D 127.0.0.1:1080 user@proxyserver
```

## Create loopback interface on Mac OS
```
sudo ifconfig lo0 alias 127.0.0.2
```

## Access github repositories using https protocol

~/.gitconfig
```
[https]
    proxy=socks5://127.0.0.1:1080
[http]
    proxy=socks5://127.0.0.1:1080
```

## Access github repositories using ssh protocol
Option 1:
```
Host github.com
    User git
    ProxyJump user@host
    LogLevel QUIET
```

Option 2:
```
Host github.com
    User git
    ProxyCommand ssh user@proxyserver -W %h:%p
    ProxyJump user@host
    LogLevel QUIET
```

## Access Web using curl
~/.curlrc
```
socks5 = 127.0.0.1:1080
```

## SSH into another server via the proxyserver
~/.ssh/config
```
Host anotherserver_IP
    ProxyCommand ssh user@proxyserver -W %h:%p
```

## Browse the web using Firefox via the proxyserver

1. Go to Network settings
2. Select Manual proxy configuration
3. Set SOCKS Host = 127.0.0.1 and Port = 1080
4. Select SOCKS_v5
5. Select Proxy DNS when using SOCKS v5

## Use socks5 proxy for Ubuntu APT

Add to /etc/apt/apt.conf
```
Acquire::http::proxy "socks5h://127.0.0.1:1080";
```

## Docker Access

Create file: /etc/systemd/system/docker.service.d/http-proxy.conf
```
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080"
Environment="HTTPS_PROXY=socks5://127.0.0.1:1080"
```

Restart docker
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Connect to proxy host
```
ssh -t -N -D "127.0.0.1:1080" root@host
```
