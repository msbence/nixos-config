#!/usr/bin/env bash

ACTIVE_VPN=$(nmcli con show --active | grep -e vpn -e wireguard | head -n 1 | cut -d ' ' -f 1)
VPN_LIST=$(nmcli con sh | grep -e vpn -e wireguard | cut -d ' ' -f 1)
BEMENU_ARGS='-l 20 -i --nb #132439 --nf #dddddd --ab #132439 --af #dddddd --sb #5D8FB0 --sf #dddddd --fb #000000 -ff #dddddd --tb #5D8FB0 --tf #dddddd --hb #5D8FB0 --hf #dddddd'
CHOICE=""
if [ -n "${ACTIVE_VPN}" ]; then
  CHOICE=$(echo -e "OFF" | bemenu $BEMENU_ARGS --fn "Nova Light Ultra SSi 20" -p "SELECT VPN:")
else
  CHOICE=$(echo -e "$VPN_LIST" | bemenu $BEMENU_ARGS --fn "Nova Light Ultra SSi 20" -p "SELECT VPN:")
fi
if [ -n "${CHOICE}" ]; then
  if [ "$CHOICE" == "OFF" ]; then
    nmcli connection down $ACTIVE_VPN
  else
    nmcli connection up $CHOICE
  fi
fi
