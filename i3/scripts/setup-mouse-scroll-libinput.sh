#!/usr/bin/env bash
# Setup increased mouse wheel scroll speed using libinput
# This method doesn't interfere with Ctrl+scroll (zoom) or Shift+scroll (horizontal)

# Get mouse device name
MOUSE_DEVICE=$(xinput list | grep -i "mouse\|pointer" | grep -v "XTEST\|keyboard" | head -1 | sed 's/.*id=\([0-9]*\).*/\1/')

if [ -z "$MOUSE_DEVICE" ]; then
    echo "Could not find mouse device" >&2
    exit 1
fi

# Set scroll acceleration (higher = faster)
# Range is typically 0.0 to 1.0, but can be higher
# 0.5 = moderate acceleration, 1.0 = high acceleration
xinput set-prop "$MOUSE_DEVICE" "libinput Scroll Method Enabled" 0, 0, 1 2>/dev/null || true
xinput set-prop "$MOUSE_DEVICE" "libinput Accel Speed" 0.5 2>/dev/null || true

echo "✓ Mouse scroll configured (Ctrl+scroll and Shift+scroll will work normally)"














