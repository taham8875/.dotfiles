#!/usr/bin/env bash
# GUI Bluetooth manager using bluetoothctl and zenity - GNOME-like experience

# Check if bluetoothctl is available
if ! command -v bluetoothctl &> /dev/null; then
    zenity --error --text="bluetoothctl not found. Please install bluez." --title="Bluetooth Error"
    exit 1
fi

# Check if Bluetooth service is running
if ! systemctl is-active --quiet bluetooth; then
    zenity --question --text="Bluetooth service is not running.\n\nYou may need to start it manually:\n  sudo systemctl start bluetooth\n\nOr enable it to start on boot:\n  sudo systemctl enable bluetooth\n\nContinue anyway?" --title="Bluetooth Service" --default-cancel
    if [ $? -ne 0 ]; then
        exit 0
    fi
    # Try to start without sudo (might work with polkit)
    systemctl start bluetooth 2>/dev/null || true
    sleep 2
    if ! systemctl is-active --quiet bluetooth; then
        zenity --warning --text="Bluetooth service could not be started.\n\nPlease start it manually in a terminal:\n  sudo systemctl start bluetooth" --title="Bluetooth Service"
        exit 1
    fi
fi

# Function to get Bluetooth power state
get_power_state() {
    bluetoothctl show | grep -q "Powered: yes" && echo "on" || echo "off"
}

# Function to toggle Bluetooth power
toggle_power() {
    if [ "$(get_power_state)" = "off" ]; then
        bluetoothctl power on 2>&1
    else
        bluetoothctl power off 2>&1
    fi
}

# Function to scan for devices
scan_devices() {
    zenity --info --text="Scanning for Bluetooth devices...\n\nPlease wait 10 seconds." --title="Bluetooth" --timeout=1 2>/dev/null &
    SCAN_PID=$!
    
    # Start scanning
    bluetoothctl scan on > /dev/null 2>&1 &
    SCAN_BG_PID=$!
    sleep 10
    
    # Stop scanning
    bluetoothctl scan off > /dev/null 2>&1
    kill $SCAN_BG_PID 2>/dev/null
    kill $SCAN_PID 2>/dev/null
}

# Main menu
while true; do
    POWER_STATE=$(get_power_state)
    POWER_TEXT=""
    if [ "$POWER_STATE" = "on" ]; then
        POWER_TEXT="● Bluetooth ON"
    else
        POWER_TEXT="○ Bluetooth OFF"
    fi
    
    # Get paired devices
    PAIRED_DEVICES=$(bluetoothctl devices Paired 2>/dev/null | awk '{print $3 "|" substr($0, index($0,$4))}')
    
    # Get available devices (recently scanned)
    AVAILABLE_DEVICES=$(bluetoothctl devices 2>/dev/null | awk '{print $3 "|" substr($0, index($0,$4))}')
    
    # Create menu options
    MENU_OPTIONS=""
    if [ "$POWER_STATE" = "off" ]; then
        MENU_OPTIONS="Turn ON Bluetooth|"
    else
        MENU_OPTIONS="Turn OFF Bluetooth|"
        if [ -n "$PAIRED_DEVICES" ]; then
            MENU_OPTIONS="${MENU_OPTIONS}---Paired Devices---|"
            MENU_OPTIONS="${MENU_OPTIONS}${PAIRED_DEVICES}|"
        fi
        MENU_OPTIONS="${MENU_OPTIONS}---Scan for Devices---|"
        if [ -n "$AVAILABLE_DEVICES" ]; then
            MENU_OPTIONS="${MENU_OPTIONS}${AVAILABLE_DEVICES}|"
        fi
    fi
    
    # Show main menu
    SELECTED=$(echo -e "$MENU_OPTIONS" | zenity --list \
        --title="Bluetooth Manager" \
        --text="Bluetooth Status: $POWER_TEXT\n\nSelect an action or device:" \
        --column="Device/Action" \
        --width=500 --height=400 \
        --print-column=1)
    
    if [ -z "$SELECTED" ] || [ "$SELECTED" = "" ]; then
        exit 0
    fi
    
    # Handle menu selection
    case "$SELECTED" in
        "Turn ON Bluetooth")
            zenity --info --text="Turning Bluetooth ON..." --title="Bluetooth" --timeout=2 &
            bluetoothctl power on 2>&1
            sleep 1
            zenity --info --text="Bluetooth is now ON" --title="Bluetooth" --timeout=2
            continue
            ;;
        "Turn OFF Bluetooth")
            zenity --question --text="Turn Bluetooth OFF? This will disconnect all devices." --title="Bluetooth" --default-cancel
            if [ $? -eq 0 ]; then
                zenity --info --text="Turning Bluetooth OFF..." --title="Bluetooth" --timeout=2 &
                bluetoothctl power off 2>&1
                sleep 1
                zenity --info --text="Bluetooth is now OFF" --title="Bluetooth" --timeout=2
            fi
            continue
            ;;
        "---Scan for Devices---")
            scan_devices
            continue
            ;;
        "---Paired Devices---")
            continue
            ;;
        *)
            # Device selected - extract MAC address
            DEVICE_MAC=$(echo "$SELECTED" | cut -d'|' -f1)
            DEVICE_NAME=$(echo "$SELECTED" | cut -d'|' -f2-)
            
            if [ -z "$DEVICE_MAC" ]; then
                continue
            fi
            
            # Check if device is already connected
            CONNECTED=$(bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: yes" && echo "yes" || echo "no")
            
            if [ "$CONNECTED" = "yes" ]; then
                # Device is connected - offer to disconnect
                zenity --question --text="Device '$DEVICE_NAME' is connected.\n\nDisconnect?" --title="Bluetooth" --default-cancel
                if [ $? -eq 0 ]; then
                    zenity --info --text="Disconnecting from $DEVICE_NAME..." --title="Bluetooth" --timeout=3 &
                    bluetoothctl disconnect "$DEVICE_MAC" 2>&1
                    sleep 2
                    if bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: no"; then
                        zenity --info --text="Disconnected from $DEVICE_NAME" --title="Bluetooth" --timeout=2
                    else
                        zenity --error --text="Failed to disconnect from $DEVICE_NAME" --title="Bluetooth Error"
                    fi
                fi
            else
                # Device is not connected - try to connect
                # Check if device is paired
                PAIRED=$(bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Paired: yes" && echo "yes" || echo "no")
                
                if [ "$PAIRED" = "no" ]; then
                    # Need to pair first
                    zenity --question --text="Device '$DEVICE_NAME' is not paired.\n\nPair and connect?" --title="Bluetooth" --default-cancel
                    if [ $? -eq 0 ]; then
                        zenity --info --text="Pairing with $DEVICE_NAME...\n\nYou may need to confirm on the device." --title="Bluetooth" --timeout=5 &
                        PAIR_OUTPUT=$(bluetoothctl pair "$DEVICE_MAC" 2>&1)
                        sleep 3
                        
                        if echo "$PAIR_OUTPUT" | grep -qi "success\|paired"; then
                            zenity --info --text="Paired with $DEVICE_NAME\n\nConnecting..." --title="Bluetooth" --timeout=3 &
                            bluetoothctl connect "$DEVICE_MAC" 2>&1
                            sleep 3
                            
                            if bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: yes"; then
                                zenity --info --text="Connected to $DEVICE_NAME" --title="Bluetooth" --timeout=3
                            else
                                zenity --error --text="Paired but failed to connect to $DEVICE_NAME" --title="Bluetooth Error"
                            fi
                        else
                            zenity --error --text="Failed to pair with $DEVICE_NAME\n\nMake sure the device is in pairing mode." --title="Bluetooth Error"
                        fi
                    fi
                else
                    # Already paired - just connect
                    zenity --info --text="Connecting to $DEVICE_NAME..." --title="Bluetooth" --timeout=3 &
                    bluetoothctl connect "$DEVICE_MAC" 2>&1
                    sleep 3
                    
                    if bluetoothctl info "$DEVICE_MAC" 2>/dev/null | grep -q "Connected: yes"; then
                        zenity --info --text="Connected to $DEVICE_NAME" --title="Bluetooth" --timeout=3
                    else
                        zenity --error --text="Failed to connect to $DEVICE_NAME\n\nMake sure the device is powered on and in range." --title="Bluetooth Error"
                    fi
                fi
            fi
            ;;
    esac
done

