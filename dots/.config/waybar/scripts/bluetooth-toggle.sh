#!/bin/bash

# Get current Bluetooth status
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$status" = "yes" ]; then
    # Turn off Bluetooth
    bluetoothctl power off
    notify-send "Bluetooth" "Bluetooth turned OFF" -i bluetooth-disabled -t 2000
else
    # Turn on Bluetooth
    bluetoothctl power on
    notify-send "Bluetooth" "Bluetooth turned ON" -i bluetooth-active -t 2000
fi
