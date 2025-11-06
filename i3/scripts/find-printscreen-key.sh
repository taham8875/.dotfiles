#!/usr/bin/env bash
# Script to find the correct key name for PrintScreen

echo "Press your PrintScreen key now..."
echo "The key name will be displayed below:"
echo ""

xev -event keyboard 2>&1 | grep -E "keysym|keycode" | head -5




