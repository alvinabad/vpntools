# How to unlock LUKS-encrypted Ubuntu Machine

## Install packages
```
sudo apt update
sudo apt install dropbear keyutils busybox-initramfs
```

Optional: Install full busybox for more tools
```
sudo apt install busybox
```

## Create an SSH key pair if you don't already have one
```
ssh-keygen -f ~/.ssh/id_rsa.myubuntu
```

Preferable, protect your private key with a passphrase.

## Copy your public key to dropbear's authorized_keys
```
sudo cp ~/.ssh/id_rsa.myubuntu.pub /etc/dropbear-initramfs/authorized_keys
```

If you already have an existing key pair, extract the public key.
```
ssh-keygen -y
```
Copy and paste to /etc/dropbear-initramfs/authorized_keys.

## Update initramfs
```
sudo update-initramfs -u

```

## If your machine uses a static IP

Add the IP information to this file: /etc/initramfs-tools/initramfs.conf
```
IP=192.168.1.7::192.168.1.1:255.255.255.0:myubuntu.com
```
Where:
```
IPADDRESS=192.168.1.7
GATEWAY=192.168.1.1
NETMASK=255.255.255.0
HOSTNAME=myubuntu.com
```

Update initramfs
```
sudo update-initramfs -u
```

## Reboot machine and remotely ssh into it
```
ssh -i ~/.ssh/id_rsa.myubuntu root@ipaddress
```

Watch out for deprecated ssh-rsa.
```
ssh -o PubkeyAcceptedKeyTypes=+ssh-rsa -i ~/.ssh/id_rsa.myubuntu root@ipaddress
```


At the shell prompt, run cryptroot-unlock to unlock the LUKS encrypted disk.
```
cryptroot-unlock
```

## Troubleshooting

### Inspect your initramfs image
```
mkdir initramfs_temp
cd initramfs_temp
sudo unmkinitramfs /boot/initrd.img-5.13.0-40-generic .
```

## Bugs:

### Ubuntu 18 - dropbear session won't terminate
Add kill all
Update /usr/share/initramfs-tools/scripts/init-bottom/dropbear. Add killall dropbear.

Add tools
```
copy_exec /bin/bash /sbin
copy_exec /bin/busybox /sbin

copy_exec /bin/lsblk
copy_exec /usr/bin/rsync
copy_exec /usr/bin/scp
copy_exec /usr/bin/ssh
copy_exec /usr/bin/curl
copy_exec /usr/bin/nmap
copy_exec /bin/nc
copy_exec /usr/bin/killall
```

## Others: Customizing initramfs

Files to play around:
```
/etc/issue*
/usr/share/initramfs-tools/scripts/init-premount/dropbear
/usr/share/initramfs-tools/scripts/init-bottom/dropbear
/usr/share/cryptsetup/initramfs/bin/cryptroot-unlock
/usr/lib/cryptsetup/functions
/usr/share/initramfs-tools/hooks/
/usr/share/initramfs-tools/hooks/dropbear
```

## Add tools to initramfs
/usr/share/initramfs-tools/hooks/misc_tools
```
#!/bin/sh

PREREQ=""

prereqs()
{
	echo "$PREREQ"
}

case "$1" in
    prereqs)
        prereqs
        exit 0
        ;;
esac

. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/bash /sbin
copy_exec /usr/bin/awk /sbin
copy_exec /usr/bin/grep /sbin
copy_exec /bin/busybox /sbin

copy_exec /usr/bin/lsblk
copy_exec /usr/bin/blkid
copy_exec /usr/bin/rsync
copy_exec /usr/bin/scp
copy_exec /usr/bin/ssh
copy_exec /usr/bin/curl
copy_exec /usr/bin/nmap
copy_exec /usr/bin/nc

cat <<EOF > "$DESTDIR/etc/profile"
export PATH=$PATH:/sbin
EOF
```

Set executable permission.
```
sudo chmod +x /usr/share/initramfs-tools/hooks/misc_tools
```

Update initramfs
```
sudo update-initramfs -u
```

## Multiple disks

###
Install keyutils package
```
apt install keyutils
```

Update /etc/crypttab to look like this:
```
dm_crypt-0 UUID=1bdb7e59-a5a4-4e67-8585-64edc002b030 none luks,initramfs,keyscript=decrypt_keyctl
dm_crypt-1 UUID=961f3951-98ed-4ba9-b4d8-abff3710da4f none luks,initramfs,keyscript=decrypt_keyctl
```

where: dm_crypt-1 is another LUKS encrypted device
