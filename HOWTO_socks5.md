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
```
Host github.com
    User git
    ProxyCommand ssh user@proxyserver -W %h:%p
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

