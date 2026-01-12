#!/usr/bin/env bash
# Adjust screen brightness
# Usage: adjust-brightness.sh [+|-]PERCENT
# Example: adjust-brightness.sh +10 (increase by 10%)
#          adjust-brightness.sh -10 (decrease by 10%)
#          adjust-brightness.sh 50  (set to 50%)

BACKLIGHT_DIR="/sys/class/backlight/intel_backlight"
BRIGHTNESS_FILE="$BACKLIGHT_DIR/brightness"
MAX_BRIGHTNESS_FILE="$BACKLIGHT_DIR/max_brightness"

# Check if backlight interface exists
if [ ! -f "$BRIGHTNESS_FILE" ] || [ ! -f "$MAX_BRIGHTNESS_FILE" ]; then
    notify-send "Brightness Error" "Backlight interface not found" 2>/dev/null || echo "Error: Backlight interface not found"
    exit 1
fi

# Read current values
CURRENT=$(cat "$BRIGHTNESS_FILE")
MAX=$(cat "$MAX_BRIGHTNESS_FILE")

# Calculate percentage
CURRENT_PERCENT=$((CURRENT * 100 / MAX))

# Parse argument
if [ -z "$1" ]; then
    # No argument - show current brightness
    notify-send "Brightness" "$CURRENT_PERCENT%" 2>/dev/null || echo "Current brightness: $CURRENT_PERCENT%"
    exit 0
fi

ARG="$1"

# Check if argument is a percentage change (+/-) or absolute value
if [[ "$ARG" =~ ^[+-] ]]; then
    # Relative change
    CHANGE_PERCENT=${ARG#+}  # Remove + sign
    CHANGE_PERCENT=${CHANGE_PERCENT#-}  # Remove - sign if present
    
    if [[ "$ARG" =~ ^\+ ]]; then
        # Increase
        NEW_PERCENT=$((CURRENT_PERCENT + CHANGE_PERCENT))
    else
        # Decrease
        NEW_PERCENT=$((CURRENT_PERCENT - CHANGE_PERCENT))
    fi
else
    # Absolute value
    NEW_PERCENT=$ARG
fi

# Clamp to valid range (1-100)
if [ "$NEW_PERCENT" -lt 1 ]; then
    NEW_PERCENT=1
elif [ "$NEW_PERCENT" -gt 100 ]; then
    NEW_PERCENT=100
fi

# Calculate new brightness value
NEW_BRIGHTNESS=$((NEW_PERCENT * MAX / 100))

# Write new brightness (requires root or proper permissions)
if [ -w "$BRIGHTNESS_FILE" ]; then
    echo "$NEW_BRIGHTNESS" > "$BRIGHTNESS_FILE"
    notify-send "Brightness" "$NEW_PERCENT%" 2>/dev/null || echo "Brightness set to: $NEW_PERCENT%"
else
    # Try with sudo (may prompt for password)
    echo "$NEW_BRIGHTNESS" | sudo tee "$BRIGHTNESS_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        notify-send "Brightness" "$NEW_PERCENT%" 2>/dev/null || echo "Brightness set to: $NEW_PERCENT%"
    else
        notify-send "Brightness Error" "Permission denied. Run: /home/taha/.config/i3/scripts/setup-brightness-permissions.sh" 2>/dev/null || echo "Error: Permission denied. Run setup-brightness-permissions.sh"
        exit 1
    fi
fi

