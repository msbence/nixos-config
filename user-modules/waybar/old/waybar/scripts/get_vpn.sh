#!/usr/bin/env bash

VPN=$(nmcli con show --active | grep -e vpn -e wireguard | head -n 1 | cut -d ' ' -f 1)
if [ -n "${VPN}" ]; then
echo "VPN ACTIVATED"
else
echo "VPN INACTIVE"
fi
