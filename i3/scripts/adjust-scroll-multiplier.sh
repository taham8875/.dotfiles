#!/usr/bin/env bash
# Interactive script to adjust mouse scroll speed using imwheel multiplier
# This actually multiplies scroll events, unlike libinput Accel Speed

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMWHEELRC="$HOME/.imwheelrc"
SETUP_SCRIPT="$SCRIPT_DIR/setup-mouse-scroll.sh"

# Get current multiplier from .imwheelrc
CURRENT=$(grep "^None.*Button4" "$IMWHEELRC" 2>/dev/null | awk -F',' '{print $4}' | tr -d ' ' || echo "5")

echo "Current scroll multiplier: $CURRENT"
echo ""
echo "Multiplier options:"
echo "  1  = Normal (1x speed)"
echo "  3  = Fast (3x speed)"
echo "  5  = Very fast (5x speed, current)"
echo "  7  = Extremely fast (7x speed)"
echo "  10 = Maximum (10x speed)"
echo ""
read -p "Enter new multiplier (1-10, or 'q' to quit): " MULTIPLIER

if [ "$MULTIPLIER" = "q" ] || [ -z "$MULTIPLIER" ]; then
    echo "Cancelled."
    exit 0
fi

# Validate input
if ! [[ "$MULTIPLIER" =~ ^[0-9]+$ ]] || [ "$MULTIPLIER" -lt 1 ] || [ "$MULTIPLIER" -gt 10 ]; then
    echo "Error: Multiplier must be a number between 1 and 10"
    exit 1
fi

# Update .imwheelrc
if [ -f "$IMWHEELRC" ]; then
    # Update vertical scroll (Button4 and Button5)
    sed -i "s/^None,.*Button4,.*/None,      Up,        Button4, $MULTIPLIER/" "$IMWHEELRC"
    sed -i "s/^None,.*Button5,.*/None,      Down,      Button5, $MULTIPLIER/" "$IMWHEELRC"
    
    # Update horizontal scroll proportionally (about 60% of vertical)
    HORIZONTAL=$((MULTIPLIER * 3 / 5))
    if [ "$HORIZONTAL" -lt 1 ]; then
        HORIZONTAL=1
    fi
    sed -i "s/^None,.*Button6,.*/None,      Left,      Button6, $HORIZONTAL/" "$IMWHEELRC"
    sed -i "s/^None,.*Button7,.*/None,      Right,     Button7, $HORIZONTAL/" "$IMWHEELRC"
    
    echo "Updated $IMWHEELRC"
else
    echo "Error: $IMWHEELRC not found" >&2
    exit 1
fi

# Restart imwheel to apply changes
"$SETUP_SCRIPT"

echo ""
echo "✓ Scroll speed updated to ${MULTIPLIER}x! Test it now."
echo "  (Ctrl+scroll and Shift+scroll still work)"

