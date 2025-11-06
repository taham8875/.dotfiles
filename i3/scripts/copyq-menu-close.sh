#!/usr/bin/env bash
# Open CopyQ menu and auto-close it on focus loss or item selection

# Try to start CopyQ server if not running
if ! pgrep -x copyq > /dev/null; then
    # Start CopyQ server
    DISPLAY=:0 copyq &
    sleep 3
fi

# Run the Python script that handles auto-close
exec /usr/bin/env python3 /home/taha/.config/i3/scripts/copyq-menu-autoclose.py
