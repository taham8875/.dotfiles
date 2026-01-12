#!/usr/bin/env bash
# Simple terminal WiFi switcher - uses saved passwords automatically

# Scan for networks
echo "Scanning for WiFi networks..."
nmcli device wifi rescan 2>/dev/null
sleep 1

# Get available networks with better formatting
echo ""
echo "Available WiFi networks:"
echo "========================"
nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE device wifi list | sort -t: -k2 -rn | \
    awk -F: '{
        status = ($4 == "*") ? " [CONNECTED]" : "";
        printf "%-30s %3s%%  %-15s%s\n", $1, $2, $3, status
    }' | nl -w2 -s'. '

echo ""
echo "Saved connections (can use without password):"
echo "=============================================="
nmcli -t -f name,type,802-11-wireless.ssid connection show | \
    grep -E ":802-11-wireless|:wifi" | \
    awk -F: '{
        if ($3 != "") {
            printf "  %-30s -> %s\n", $3, $1
        }
    }'

echo ""
read -p "Enter network name (SSID) to connect: " SSID

if [ -z "$SSID" ]; then
    echo "Cancelled."
    exit 0
fi

# Check if already connected
CURRENT=$(nmcli -t -f active,ssid dev wifi | grep -E "^yes:" | cut -d: -f2)
if [ "$SSID" = "$CURRENT" ]; then
    echo "Already connected to $SSID"
    exit 0
fi

# Find saved connection profile for this SSID
SAVED_PROFILE=""
for conn in $(nmcli -t -f name,type connection show | grep -E ":802-11-wireless|:wifi" | cut -d: -f1); do
    conn_ssid=$(nmcli -t -f 802-11-wireless.ssid connection show "$conn" 2>/dev/null | cut -d: -f2)
    if [ "$conn_ssid" = "$SSID" ]; then
        SAVED_PROFILE="$conn"
        break
    fi
done

# Connect using saved profile if available, otherwise try direct connection
if [ -n "$SAVED_PROFILE" ]; then
    echo "Connecting to $SSID using saved profile '$SAVED_PROFILE'..."
    if nmcli connection up "$SAVED_PROFILE"; then
        echo "✓ Connected to $SSID"
        notify-send "WiFi" "Connected to $SSID" 2>/dev/null || true
    else
        echo "✗ Failed to connect"
        exit 1
    fi
else
    # Try connecting directly (will use saved password if NetworkManager has it)
    echo "Connecting to $SSID..."
    if nmcli device wifi connect "$SSID" 2>&1; then
        echo "✓ Connected to $SSID"
        notify-send "WiFi" "Connected to $SSID" 2>/dev/null || true
    else
        echo "✗ Connection failed. The network may require a password."
        echo "  Use: nmcli device wifi connect \"$SSID\" password \"PASSWORD\""
        exit 1
    fi
fi



