#!/bin/bash

# Check internet connection
check_internet() {
    local host="google.com"
    if ping -c 1 -W 2 "$host" > /dev/null 2>&1; then
        return 0
    else
        echo "Device is not connected to the internet."
        return 1
    fi
}

# List available networks
list_networks() {
    echo -e "Scanning for available Wi-Fi networks...\n"
    nmcli dev wifi list
    echo
}

# Connect to a Wi-Fi network
connect_wifi() {
    local ssid security
    while true; do
        read -p "Enter the Wi-Fi network name (SSID): " ssid

        # Get the security type for the selected SSID
        security=$(nmcli dev wifi list | grep -w "$ssid" | awk '{print $NF}')

        if [[ -z "$security" ]]; then
            echo "Network $ssid not found. Please check the SSID and try again."
            continue
        fi

        # Valid SSID found, break the loop
        break
    done

    if [[ "$security" == "--" ]]; then
        # Open network
        echo "Attempting to connect to open network $ssid..."
        if nmcli dev wifi connect "$ssid"; then
            echo "Successfully connected to open network $ssid."
            return 0
        else
            echo "Failed to connect to $ssid. Please check the network and try again."
            return 1
        fi
    else
        # Secure network
        read -s -p "Enter the password for $ssid: " password
        echo
        echo "Attempting to connect to secure network $ssid..."
        if nmcli dev wifi connect "$ssid" password "$password"; then
            echo "Successfully connected to secure network $ssid."
            return 0
        else
            echo "Failed to connect to $ssid. Please check the credentials and try again."
            return 1
        fi
    fi
}


# --------------------- Main -----------------------------

if check_internet; then
    echo "Device is connected to the internet."
else
    list_networks
    if connect_wifi && check_internet; then
        echo "Successfully connected to the internet!"
    else
        echo "Unable to establish an internet connection. Please troubleshoot."
    fi
fi

