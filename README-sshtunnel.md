# Connect to host2 via host1
```
ssh -t -L 127.0.0.1:port:127.0.0.1:port user@host1 ssh -t -L 127.0.0.1:port:host2:port -N user@host2
```
