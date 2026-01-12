#!/usr/bin/env bash
# Setup faster mouse scroll speed WITHOUT breaking Ctrl+scroll or Shift+scroll
# Uses xinput acceleration settings

MOUSE_NAME="UGREEN Receiver  Mouse"
MOUSE_ID=$(xinput list --id-only "$MOUSE_NAME" 2>/dev/null)

if [ -z "$MOUSE_ID" ]; then
    echo "Mouse '$MOUSE_NAME' not found. Trying to find any mouse..." >&2
    MOUSE_ID=$(xinput list | grep -i "mouse\|pointer" | grep -v "XTEST\|keyboard" | head -1 | sed 's/.*id=\([0-9]*\).*/\1/')
fi

if [ -z "$MOUSE_ID" ]; then
    echo "Error: Could not find mouse device" >&2
    exit 1
fi

# Get acceleration speed (default: 0.3 = slightly faster)
# Range: -1.0 to 1.0, where 0.0 is default
# Higher = faster pointer movement (affects scrolling feel)
ACCEL_SPEED="${1:-0.3}"  # Default to 0.3 if not provided

# Validate input
if ! [[ "$ACCEL_SPEED" =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
    echo "Error: Acceleration must be a number between -1.0 and 1.0" >&2
    exit 1
fi

echo "Configuring mouse device ID: $MOUSE_ID"
echo "Setting acceleration speed to: $ACCEL_SPEED"

# Set pointer acceleration (affects scrolling responsiveness)
xinput set-prop "$MOUSE_ID" "libinput Accel Speed" "$ACCEL_SPEED" 2>/dev/null || {
    echo "Error: Could not set acceleration. Your mouse may not support this." >&2
    exit 1
}

echo "✓ Mouse acceleration configured"
echo "  (Ctrl+scroll and Shift+scroll will still work)"
echo ""
echo "To adjust speed, run: $0 [acceleration]"
echo "  Examples:"
echo "    $0 0.1  (slightly faster)"
echo "    $0 0.3  (moderate, default)"
echo "    $0 0.5  (fast)"
echo "    $0 0.7  (very fast)"
echo "    $0 0.0  (normal/default)"
