#!/usr/bin/env bash
# GUI WiFi network switcher using zenity - GNOME-like experience
# Automatically uses saved passwords when available

# Get the WiFi device name
WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE device | grep -w wifi | cut -d: -f1 | head -1)

if [ -z "$WIFI_DEVICE" ]; then
    zenity --error --text="No WiFi device found" --title="WiFi Error"
    exit 1
fi

# Get currently connected network
CURRENT_SSID=$(nmcli -t -f active,ssid dev wifi | grep -E "^yes:" | cut -d: -f2)

# Scan for available networks
zenity --info --text="Scanning for WiFi networks..." --title="WiFi" --timeout=2 2>/dev/null &
SCAN_PID=$!
nmcli device wifi rescan 2>/dev/null
sleep 2
kill $SCAN_PID 2>/dev/null

# Get list of available networks and format for zenity
# Include connection status indicator
NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list | sort -t: -k2 -rn)

if [ -z "$NETWORKS" ]; then
    zenity --error --text="No WiFi networks found" --title="WiFi Error"
    exit 1
fi

# Get list of saved connections (profiles that have passwords saved)
SAVED_CONNECTIONS=$(nmcli -t -f name,type connection show | grep -E "802-11-wireless|wifi" | cut -d: -f1)

# Format networks for zenity list dialog
# Format: SSID|Signal%|Security|Status
NETWORK_LIST=$(echo "$NETWORKS" | awk -F: '{
    status = ($4 == "*") ? "● Connected" : "";
    # Check if this SSID has a saved connection
    saved = "";
    cmd = "echo \"'"$SAVED_CONNECTIONS"'\" | grep -i \"" $1 "\"";
    if (cmd | getline) {
        saved = "✓ Saved";
        close(cmd);
    }
    if (status == "" && saved != "") status = saved;
    printf "%s|%s%%|%s|%s\n", $1, $2, $3, status
}')

# Show network selection dialog
SELECTED=$(echo "$NETWORK_LIST" | zenity --list \
    --title="Select WiFi Network" \
    --text="Choose a WiFi network to connect to:" \
    --column="Network Name" --column="Signal" --column="Security" --column="Status" \
    --width=600 --height=400 \
    --print-column=1)

if [ -z "$SELECTED" ] || [ "$SELECTED" = "" ]; then
    exit 0
fi

SSID="$SELECTED"

# Check if already connected to this network
if [ "$SSID" = "$CURRENT_SSID" ]; then
    zenity --info --text="Already connected to $SSID" --title="WiFi" --timeout=2
    exit 0
fi

# Check if this network has a saved connection/profile
# NetworkManager stores SSID in the connection profile
SAVED_PROFILE=""
for conn in $(nmcli -t -f name,type connection show | grep -E ":802-11-wireless|:wifi" | cut -d: -f1); do
    conn_ssid=$(nmcli -t -f 802-11-wireless.ssid connection show "$conn" 2>/dev/null | cut -d: -f2)
    if [ "$conn_ssid" = "$SSID" ]; then
        SAVED_PROFILE="$conn"
        break
    fi
done

# Get security info for selected network
SECURITY=$(echo "$NETWORKS" | grep "^$SSID:" | cut -d: -f3)

# Show connecting notification
zenity --info --text="Connecting to $SSID..." --title="WiFi" --timeout=3 &
CONNECT_PID=$!

# Try to connect
# First, try connecting without password - nmcli will use saved credentials if available
OUTPUT=$(nmcli device wifi connect "$SSID" 2>&1)
RESULT=$?

# If connection failed and network is secured, check if we need a password
if [ $RESULT -ne 0 ] && [ "$SECURITY" != "--" ] && [ -n "$SECURITY" ]; then
    # Check if error suggests we need a password (not just a saved profile issue)
    if echo "$OUTPUT" | grep -qi "password\|secret\|psk"; then
        # No saved password, prompt for it
        kill $CONNECT_PID 2>/dev/null
        PASSWORD=$(zenity --password --title="WiFi Password" --text="Enter password for '$SSID':")
        
        if [ -z "$PASSWORD" ]; then
            zenity --info --text="Connection cancelled" --title="WiFi" --timeout=2
            exit 0
        fi
        
        # Show connecting notification again
        zenity --info --text="Connecting to $SSID..." --title="WiFi" --timeout=3 &
        CONNECT_PID=$!
        
        # Connect with password (NetworkManager will save it automatically)
        OUTPUT=$(nmcli device wifi connect "$SSID" password "$PASSWORD" 2>&1)
        RESULT=$?
    fi
fi

kill $CONNECT_PID 2>/dev/null

# Show result
if [ $RESULT -eq 0 ]; then
    zenity --info --text="Successfully connected to $SSID" --title="WiFi" --timeout=3
else
    zenity --error --text="Failed to connect to $SSID\n\n$OUTPUT" --title="WiFi Error"
fi

