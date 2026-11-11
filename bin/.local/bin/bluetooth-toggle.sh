#!/usr/bin/env bash
# bluetooth-toggle.sh — power the Bluetooth adapter on/off (waybar right-click)

if bluetoothctl show | grep -q 'Powered: yes'; then
    bluetoothctl power off
else
    # a soft-blocked (rfkill) adapter refuses to power on, so unblock first
    rfkill unblock bluetooth 2>/dev/null
    bluetoothctl power on
fi
