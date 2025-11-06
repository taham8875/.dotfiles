#!/usr/bin/env bash
# Screenshot script with area selection support
# Supports: flameshot, gnome-screenshot, maim, scrot

# Log for debugging
LOG_FILE="/tmp/i3-screenshot.log"
echo "$(date): Screenshot script started" >> "$LOG_FILE"

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
echo "Screenshot dir: $SCREENSHOT_DIR" >> "$LOG_FILE"

# Generate timestamped filename
FILENAME="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

# Try flameshot first (best tool for interactive selection)
if command -v flameshot &> /dev/null; then
    echo "Using flameshot" >> "$LOG_FILE"
    flameshot gui -p "$SCREENSHOT_DIR" 2>&1 >> "$LOG_FILE"
    exit 0
fi

# Try gnome-screenshot (GNOME-like interactive mode)
if command -v gnome-screenshot &> /dev/null; then
    echo "Using gnome-screenshot" >> "$LOG_FILE"
    gnome-screenshot --interactive --file="$FILENAME" 2>&1 >> "$LOG_FILE"
    exit 0
fi

# Try maim with slop (area selection)
if command -v maim &> /dev/null && command -v slop &> /dev/null; then
    maim -s "$FILENAME" && notify-send "Screenshot saved" "$FILENAME" 2>/dev/null || echo "Screenshot saved: $FILENAME"
    exit 0
fi

# Fallback: use scrot (simple but less interactive)
if command -v scrot &> /dev/null; then
    scrot -s "$FILENAME" && notify-send "Screenshot saved" "$FILENAME" 2>/dev/null || echo "Screenshot saved: $FILENAME"
    exit 0
fi

# If nothing is available, show error
notify-send "Screenshot Error" "No screenshot tool found. Please install flameshot, gnome-screenshot, maim, or scrot." 2>/dev/null || \
    echo "Error: No screenshot tool found. Please install flameshot, gnome-screenshot, maim, or scrot."
exit 1

