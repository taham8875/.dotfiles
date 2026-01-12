#!/usr/bin/env bash
# Interactive WiFi network switcher using nmcli

# Get the WiFi device name
WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE device | grep -w wifi | cut -d: -f1 | head -1)

if [ -z "$WIFI_DEVICE" ]; then
    notify-send "WiFi Error" "No WiFi device found" -u critical
    exit 1
fi

# Scan for available networks
notify-send "WiFi" "Scanning for networks..." -t 2000
nmcli device wifi rescan 2>/dev/null
sleep 2

# Get list of available networks
NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | sort -t: -k2 -rn)

if [ -z "$NETWORKS" ]; then
    notify-send "WiFi Error" "No networks found" -u critical
    exit 1
fi

# Show networks in a menu using rofi or dmenu
if command -v rofi &> /dev/null; then
    # Use rofi to show network list
    SELECTED=$(echo "$NETWORKS" | awk -F: '{print $1 " (" $2 "%)"}' | rofi -dmenu -i -p "Select WiFi Network" -theme-str 'listview { lines: 10; }')
    SSID=$(echo "$SELECTED" | cut -d' ' -f1)
elif command -v dmenu &> /dev/null; then
    SELECTED=$(echo "$NETWORKS" | awk -F: '{print $1 " (" $2 "%)"}' | dmenu -i -l 10 -p "Select WiFi Network:")
    SSID=$(echo "$SELECTED" | cut -d' ' -f1)
else
    # Fallback: show in terminal and prompt
    echo "Available WiFi Networks:"
    echo "$NETWORKS" | awk -F: '{printf "%-30s %s%% %s\n", $1, $2, $3}'
    echo ""
    read -p "Enter SSID to connect: " SSID
fi

if [ -z "$SSID" ] || [ "$SSID" = "" ]; then
    exit 0
fi

# Check if network requires password
SECURITY=$(echo "$NETWORKS" | grep "^$SSID:" | cut -d: -f3)

if [ "$SECURITY" != "--" ] && [ -n "$SECURITY" ]; then
    # Network is secured, prompt for password
    if command -v rofi &> /dev/null; then
        PASSWORD=$(rofi -dmenu -password -p "Enter password for $SSID:" -theme-str 'entry { placeholder: "Password"; }')
    elif command -v dmenu &> /dev/null; then
        PASSWORD=$(dmenu -p "Enter password for $SSID:" < /dev/null)
    else
        read -sp "Enter password for $SSID: " PASSWORD
        echo
    fi
    
    if [ -z "$PASSWORD" ]; then
        notify-send "WiFi" "Connection cancelled" -t 2000
        exit 0
    fi
    
    # Connect with password
    notify-send "WiFi" "Connecting to $SSID..." -t 3000
    nmcli device wifi connect "$SSID" password "$PASSWORD" 2>&1 | while read line; do
        if echo "$line" | grep -q "successfully activated"; then
            notify-send "WiFi" "Connected to $SSID" -t 3000
        elif echo "$line" | grep -qi "error\|failed"; then
            notify-send "WiFi Error" "Failed to connect to $SSID" -u critical
        fi
    done
else
    # Open network, connect without password
    notify-send "WiFi" "Connecting to $SSID..." -t 3000
    nmcli device wifi connect "$SSID" 2>&1 | while read line; do
        if echo "$line" | grep -q "successfully activated"; then
            notify-send "WiFi" "Connected to $SSID" -t 3000
        elif echo "$line" | grep -qi "error\|failed"; then
            notify-send "WiFi Error" "Failed to connect to $SSID" -u critical
        fi
    done
fi



