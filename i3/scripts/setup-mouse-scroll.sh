#!/usr/bin/env bash
# Setup increased mouse wheel scroll speed using imwheel
# This script starts imwheel with increased scroll multiplier

# Kill any existing imwheel processes
killall imwheel 2>/dev/null || true

# Wait a moment for processes to terminate
sleep 0.5

# Start imwheel with button 4 and 5 (scroll wheel)
# The configuration is in ~/.imwheelrc
# You can adjust the multiplier in that file (default is 5x speed)
if command -v imwheel >/dev/null 2>&1; then
    imwheel -b "4 5" >/dev/null 2>&1 &
    # Also handle horizontal scroll if available (buttons 6 and 7)
    # imwheel -b "4 5 6 7" >/dev/null 2>&1 &
else
    echo "imwheel not found. Install it with: sudo apt install imwheel" >&2
    exit 1
fi

