## Download Cygwin

https://www.cygwin.com/setup-x86_64.exe

## Install Cygwin without admin

Open CMD terminal and run setup with with --no-admin option:
```
setup-x86_64.exe --no-admin
```

## Run SSHD

Edit Cygwin.bat and add this line before bash login:
```
set CYGWIN=binmode ntsec
```

Launch Cygwin.bat and run this command:
```
ssh-host-config
```

Follow default settings. Do not install sshd as a service.

To launch sshd, run:
```
/usr/sbin/sshd
```

## References

* https://docs.oracle.com/cd/E24628_01/install.121/e22624/preinstall_req_cygwin_ssh.htm#EMBSC281
