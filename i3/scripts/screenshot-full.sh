#!/usr/bin/env bash
# Full screen screenshot

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="$SCREENSHOT_DIR/screenshot-full-$(date +%Y%m%d-%H%M%S).png"

# Try flameshot
if command -v flameshot &> /dev/null; then
    flameshot full -p "$SCREENSHOT_DIR"
    exit 0
fi

# Try gnome-screenshot
if command -v gnome-screenshot &> /dev/null; then
    gnome-screenshot --file="$FILENAME"
    exit 0
fi

# Try maim
if command -v maim &> /dev/null; then
    maim "$FILENAME" && notify-send "Screenshot saved" "$FILENAME" 2>/dev/null || echo "Screenshot saved: $FILENAME"
    exit 0
fi

# Fallback: scrot
if command -v scrot &> /dev/null; then
    scrot "$FILENAME" && notify-send "Screenshot saved" "$FILENAME" 2>/dev/null || echo "Screenshot saved: $FILENAME"
    exit 0
fi

notify-send "Screenshot Error" "No screenshot tool found." 2>/dev/null || \
    echo "Error: No screenshot tool found."
exit 1


