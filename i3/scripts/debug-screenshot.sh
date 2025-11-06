#!/usr/bin/env bash
# Debug script to test screenshot functionality

echo "Screenshot script called at $(date)" >> /tmp/i3-screenshot-debug.log
echo "PATH: $PATH" >> /tmp/i3-screenshot-debug.log
echo "PWD: $(pwd)" >> /tmp/i3-screenshot-debug.log
echo "User: $(whoami)" >> /tmp/i3-screenshot-debug.log

# Check for tools
echo "Checking for screenshot tools..." >> /tmp/i3-screenshot-debug.log
which flameshot >> /tmp/i3-screenshot-debug.log 2>&1
which gnome-screenshot >> /tmp/i3-screenshot-debug.log 2>&1
which maim >> /tmp/i3-screenshot-debug.log 2>&1
which scrot >> /tmp/i3-screenshot-debug.log 2>&1

# Try to show notification
notify-send "Screenshot Debug" "Script was called!" 2>&1 >> /tmp/i3-screenshot-debug.log

# Try to run the actual screenshot
if command -v gnome-screenshot &> /dev/null; then
    echo "Found gnome-screenshot, trying to run..." >> /tmp/i3-screenshot-debug.log
    gnome-screenshot --interactive 2>&1 >> /tmp/i3-screenshot-debug.log
else
    echo "No screenshot tool found!" >> /tmp/i3-screenshot-debug.log
    notify-send "Screenshot Error" "No screenshot tool installed. Check /tmp/i3-screenshot-debug.log" 2>&1
fi




