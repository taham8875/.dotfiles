#!/usr/bin/env bash
# Test script to find PrintScreen key

echo "=== Testing PrintScreen Key Detection ==="
echo ""
echo "Method 1: Using xev (press PrintScreen, then Ctrl+C to exit)"
echo "Press PrintScreen now..."
xev -event keyboard 2>&1 | grep --line-buffered -E "(keysym|keycode|state)" | head -20

echo ""
echo "Method 2: Using showkey (run as root: sudo showkey)"
echo "Method 3: Check if key is captured by another program"
echo ""
echo "Checking if PrintScreen is already bound in i3:"
i3-msg -t get_config | grep -i print || echo "No Print binding found in i3 config"


