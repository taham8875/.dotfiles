#!/usr/bin/env bash
# Simple terminal Bluetooth manager using bluetoothctl

# Check if bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    echo "Error: bluetoothctl not found. Please install bluez."
    exit 1
fi

# Check if Bluetooth service is running
if ! systemctl is-active --quiet bluetooth; then
    echo "Bluetooth service is not running."
    read -p "Start Bluetooth service? (y/n): " START_SERVICE
    if [ "$START_SERVICE" = "y" ] || [ "$START_SERVICE" = "Y" ]; then
        echo "Starting Bluetooth service..."
        sudo systemctl start bluetooth
        sleep 2
    else
        exit 0
    fi
fi

# Function to get Bluetooth power state
get_power_state() {
    bluetoothctl show | grep -q "Powered: yes" && echo "on" || echo "off"
}

# Function to show device list
show_devices() {
    echo ""
    echo "Paired Devices:"
    echo "==============="
    PAIRED=$(bluetoothctl devices Paired 2>/dev/null)
    if [ -z "$PAIRED" ]; then
        echo "  (none)"
    else
        echo "$PAIRED" | while read line; do
            MAC=$(echo "$line" | awk '{print $2}')
            NAME=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}')
            CONNECTED=$(bluetoothctl info "$MAC" 2>/dev/null | grep -q "Connected: yes" && echo " [CONNECTED]" || echo "")
            echo "  $MAC  $NAME$CONNECTED"
        done
    fi
    
    echo ""
    echo "Available Devices:"
    echo "=================="
    AVAILABLE=$(bluetoothctl devices 2>/dev/null)
    if [ -z "$AVAILABLE" ]; then
        echo "  (none - run scan first)"
    else
        echo "$AVAILABLE" | while read line; do
            MAC=$(echo "$line" | awk '{print $2}')
            NAME=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}')
            PAIRED=$(bluetoothctl info "$MAC" 2>/dev/null | grep -q "Paired: yes" && echo " [PAIRED]" || echo "")
            CONNECTED=$(bluetoothctl info "$MAC" 2>/dev/null | grep -q "Connected: yes" && echo " [CONNECTED]" || echo "")
            echo "  $MAC  $NAME$PAIRED$CONNECTED"
        done
    fi
}

# Main menu loop
while true; do
    POWER_STATE=$(get_power_state)
    echo ""
    echo "=========================================="
    echo "Bluetooth Manager"
    echo "=========================================="
    echo "Status: Bluetooth is $POWER_STATE"
    echo ""
    echo "Options:"
    echo "  1. Toggle Bluetooth power"
    echo "  2. Scan for devices"
    echo "  3. Show devices"
    echo "  4. Connect to device"
    echo "  5. Disconnect from device"
    echo "  6. Pair new device"
    echo "  7. Remove device"
    echo "  8. Exit"
    echo ""
    read -p "Select option (1-8): " OPTION
    
    case "$OPTION" in
        1)
            if [ "$POWER_STATE" = "off" ]; then
                echo "Turning Bluetooth ON..."
                bluetoothctl power on
            else
                echo "Turning Bluetooth OFF..."
                bluetoothctl power off
            fi
            sleep 1
            ;;
        2)
            echo "Scanning for devices (10 seconds)..."
            bluetoothctl scan on &
            SCAN_PID=$!
            sleep 10
            bluetoothctl scan off
            kill $SCAN_PID 2>/dev/null
            echo "Scan complete."
            ;;
        3)
            show_devices
            ;;
        4)
            show_devices
            echo ""
            read -p "Enter device MAC address to connect: " MAC
            if [ -n "$MAC" ]; then
                echo "Connecting to $MAC..."
                bluetoothctl connect "$MAC"
                sleep 2
                if bluetoothctl info "$MAC" 2>/dev/null | grep -q "Connected: yes"; then
                    echo "✓ Connected successfully"
                    notify-send "Bluetooth" "Connected to device" 2>/dev/null || true
                else
                    echo "✗ Connection failed"
                fi
            fi
            ;;
        5)
            show_devices
            echo ""
            read -p "Enter device MAC address to disconnect: " MAC
            if [ -n "$MAC" ]; then
                echo "Disconnecting from $MAC..."
                bluetoothctl disconnect "$MAC"
                sleep 2
                if bluetoothctl info "$MAC" 2>/dev/null | grep -q "Connected: no"; then
                    echo "✓ Disconnected successfully"
                    notify-send "Bluetooth" "Disconnected from device" 2>/dev/null || true
                else
                    echo "✗ Disconnect failed"
                fi
            fi
            ;;
        6)
            show_devices
            echo ""
            read -p "Enter device MAC address to pair: " MAC
            if [ -n "$MAC" ]; then
                echo "Pairing with $MAC..."
                echo "Make sure the device is in pairing mode."
                bluetoothctl pair "$MAC"
                sleep 2
                if bluetoothctl info "$MAC" 2>/dev/null | grep -q "Paired: yes"; then
                    echo "✓ Paired successfully"
                    read -p "Connect now? (y/n): " CONNECT_NOW
                    if [ "$CONNECT_NOW" = "y" ] || [ "$CONNECT_NOW" = "Y" ]; then
                        bluetoothctl connect "$MAC"
                        sleep 2
                    fi
                else
                    echo "✗ Pairing failed"
                fi
            fi
            ;;
        7)
            show_devices
            echo ""
            read -p "Enter device MAC address to remove: " MAC
            if [ -n "$MAC" ]; then
                echo "Removing $MAC..."
                bluetoothctl remove "$MAC"
                sleep 1
                echo "✓ Device removed"
            fi
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please select 1-8."
            ;;
    esac
done



