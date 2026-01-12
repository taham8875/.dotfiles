#!/usr/bin/env bash
# Test script to verify Ctrl+scroll and Shift+scroll events

echo "Testing scroll with modifiers..."
echo ""
echo "Instructions:"
echo "1. Keep this terminal focused"
echo "2. Try Ctrl+scroll - should see events"
echo "3. Try Shift+scroll - should see events"
echo ""
echo "Starting xev to monitor events (press Ctrl+C to stop)..."
echo ""

xev -event button | grep -E "state|button|ControlMask|ShiftMask" &
XEV_PID=$!

sleep 10
kill $XEV_PID 2>/dev/null

echo ""
echo "Test complete. If you saw events with ControlMask or ShiftMask,"
echo "the modifiers are working at X11 level."














