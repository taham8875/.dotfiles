#!/usr/bin/env bash
# Kill Huion software on startup
# Waits a few seconds for it to start, then kills it

sleep 3
pkill -f huion || true
pkill -f Huion || true





















