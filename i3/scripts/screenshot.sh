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

# Try maim with slop first (doesn't create GUI windows, prevents layout shifts)
if command -v maim &> /dev/null && command -v slop &> /dev/null; then
    echo "Using maim" >> "$LOG_FILE"
    if maim -s "$FILENAME"; then
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

# Try flameshot (creates GUI, but we've configured it to not affect layout)
# Use --clipboard option to copy to clipboard
if command -v flameshot &> /dev/null; then
    echo "Using flameshot" >> "$LOG_FILE"
    # Launch in background, copy to clipboard and save to file
    flameshot gui -p "$SCREENSHOT_DIR" --clipboard 2>&1 >> "$LOG_FILE" &
    exit 0
fi

# Try gnome-screenshot (GNOME-like interactive mode)
if command -v gnome-screenshot &> /dev/null; then
    echo "Using gnome-screenshot" >> "$LOG_FILE"
    if gnome-screenshot --interactive --file="$FILENAME" 2>&1 >> "$LOG_FILE"; then
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

# Fallback: use scrot (simple but less interactive)
if command -v scrot &> /dev/null; then
    if scrot -s "$FILENAME"; then
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

# If nothing is available, show error
notify-send "Screenshot Error" "No screenshot tool found. Please install flameshot, gnome-screenshot, maim, or scrot." 2>/dev/null || \
    echo "Error: No screenshot tool found. Please install flameshot, gnome-screenshot, maim, or scrot."
exit 1

