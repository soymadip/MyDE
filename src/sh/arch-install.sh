#!/usr/bin/env bash

#     _             _           _           _        _ _
#    / \   _ __ ___| |__       (_)_ __  ___| |_ __ _| | | ___ _ __
#   / _ \ | '__/ __| '_ \ _____| | '_ \/ __| __/ _` | | |/ _ \ '__|
#  / ___ \| | | (__| | | |_____| | | | \__ \ || (_| | | |  __/ |
# /_/   \_\_|  \___|_| |_|     |_|_| |_|___/\__\__,_|_|_|\___|_|

#----------------------------------------------------

# Check if device is connected to internet
bash modules/check-network.sh

# Set timezone
timedatectl set-timesone Asia/Kolkata
