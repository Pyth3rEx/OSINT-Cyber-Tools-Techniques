#!/bin/bash
# For Debian/Kali Linux
# Save in the same folder as the vpn.conf files and run from a root terminal.
for file in *.conf; do
    c="${file%.*}"
    sudo nmcli connection import type wireguard file $file && sudo nmcli connection modify $c autoconnect no && sudo nmcli con down $c
done
