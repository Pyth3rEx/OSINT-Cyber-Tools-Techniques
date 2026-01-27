#!/bin/bash

# Get local IP (first non-loopback interface)
local_line=$(ip -o -4 addr show | awk '!/ lo / && !/tun[0-9]/ && !/wg[0-9]/ {print $2": "$4}' | head -n1)
local_ip=$(echo "$local_line" | cut -d/ -f1)

# Detect VPN interface and its IP
vpn_iface=$(ip -o -4 addr show | awk '/tun[0-9]|wg[0-9]/ {print $2; exit}')
if [ -n "$vpn_iface" ]; then
    vpn_ip=$(ip -o -4 addr show dev "$vpn_iface" | awk '{print $4}' | cut -d/ -f1)
    vpn_status="🔐 $vpn_iface: $vpn_ip"
else
    vpn_status="🔓 VPN: none"
fi

# Get public IP (via VPN if active)
public_ip=$(
  curl -s --max-time 4 https://icanhazip.com ||
  curl -s --max-time 4 https://ifconfig.co/ip ||
  curl -s --max-time 4 https://ident.me
)
[ -z "$public_ip" ] && public_ip="unreachable"

# Output for XFCE Genmon
echo "<txt>📡 $local_ip | $vpn_status | 🌐 $public_ip</txt>"
