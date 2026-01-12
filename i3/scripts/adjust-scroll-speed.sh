#!/usr/bin/env bash
# Interactive script to adjust mouse scroll speed
# Uses libinput acceleration (preserves Ctrl+scroll and Shift+scroll)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_SCRIPT="$SCRIPT_DIR/setup-mouse-scroll-fast.sh"

# Get current acceleration
CURRENT=$(xinput list-props "UGREEN Receiver  Mouse" 2>/dev/null | grep "libinput Accel Speed" | awk '{print $4}' || echo "0.0")

echo "Current scroll acceleration: $CURRENT"
echo ""
echo "Speed options:"
echo "  0.0  = Normal (default)"
echo "  0.1  = Slightly faster"
echo "  0.3  = Moderate (recommended)"
echo "  0.5  = Fast"
echo "  0.7  = Very fast"
echo ""
read -p "Enter new acceleration (0.0-0.7, or 'q' to quit): " SPEED

if [ "$SPEED" = "q" ] || [ -z "$SPEED" ]; then
    echo "Cancelled."
    exit 0
fi

# Validate input
if ! [[ "$SPEED" =~ ^[0-9]*\.?[0-9]+$ ]] || (( $(echo "$SPEED < 0.0" | bc -l) )) || (( $(echo "$SPEED > 0.7" | bc -l) )); then
    echo "Error: Acceleration must be a number between 0.0 and 0.7"
    exit 1
fi

# Apply the new speed
"$SETUP_SCRIPT" "$SPEED"

echo ""
echo "✓ Scroll speed updated! Test it now."
echo "  (Ctrl+scroll and Shift+scroll still work)"
