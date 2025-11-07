#!/usr/bin/env bash
# Full screen screenshot

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="$SCREENSHOT_DIR/screenshot-full-$(date +%Y%m%d-%H%M%S).png"

# Try flameshot (full screen, no GUI so no layout shift)
if command -v flameshot &> /dev/null; then
    flameshot full -p "$SCREENSHOT_DIR" --clipboard && notify-send "Screenshot saved" "Full screen screenshot saved to clipboard and $SCREENSHOT_DIR" 2>/dev/null
    exit 0
fi

# Try gnome-screenshot
if command -v gnome-screenshot &> /dev/null; then
    if gnome-screenshot --file="$FILENAME"; then
        # Copy to clipboard
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard -t image/png < "$FILENAME"
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --input < "$FILENAME"
        fi
        notify-send "Screenshot saved" "Saved to clipboard and $FILENAME" 2>/dev/null
    fi
    exit 0
fi

# Try maim
if command -v maim &> /dev/null; then
    if maim "$FILENAME"; then
        # Copy to clipboard
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard -t image/png < "$FILENAME"
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --input < "$FILENAME"
        fi
        notify-send "Screenshot saved" "Saved to clipboard and $FILENAME" 2>/dev/null || echo "Screenshot saved to clipboard and $FILENAME"
    fi
    exit 0
fi

# Fallback: scrot
if command -v scrot &> /dev/null; then
    if scrot "$FILENAME"; then
        # Copy to clipboard
        if command -v xclip &> /dev/null; then
            xclip -selection clipboard -t image/png < "$FILENAME"
        elif command -v xsel &> /dev/null; then
            xsel --clipboard --input < "$FILENAME"
        fi
        notify-send "Screenshot saved" "Saved to clipboard and $FILENAME" 2>/dev/null || echo "Screenshot saved to clipboard and $FILENAME"
    fi
    exit 0
fi

notify-send "Screenshot Error" "No screenshot tool found." 2>/dev/null || \
    echo "Error: No screenshot tool found."
exit 1




