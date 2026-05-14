# References
https://nordvpn.com/download/linux/
https://support.nordvpn.com/hc/en-us/articles/20196094470929-How-to-install-the-NordVPN-app-on-Linux-distributions

## CLI Install
```
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
```
Logout and log back in for user settings to take effect

## GUI Install
```
sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh) -p nordvpn-gui
```

# Login/Logout
```
nordvpn login --token xxxx
nordvpn logout --persist-token
```

# Connect
```
nordvpn connect
nordvpn connect --group Onion_Over_VPN
nordvpn connect Double_VPN
```

# Disconnect
```
nordvpn disconnect
```

# Set local network
```
nordvpn set lan-discovery on
nordvpn set killswitch on
nordvpn set autoconnect on
nordvpn set autoconnect on <country_code+server_number>
nordvpn set analytics off
nordvpn set dns 1.1.1.1 1.0.0.1
nordvpn set technology OpenVPN
```

# Firewall Whitelist
```
nordvpn allowlist add subnet 192.168.95.0/24
```

# List Groups
```
nordvpn groups
```
