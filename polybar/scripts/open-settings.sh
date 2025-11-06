#!/usr/bin/env bash
# Open system settings
# Try gnome-control-center first, fallback to other options
if command -v gnome-control-center &> /dev/null && [ -n "$GNOME_DESKTOP_SESSION_ID" ]; then
    gnome-control-center &
elif command -v xfce4-settings-manager &> /dev/null; then
    xfce4-settings-manager &
elif command -v lxqt-config &> /dev/null; then
    lxqt-config &
else
    # Fallback: open file manager to home directory
    xdg-open ~ &
fi

