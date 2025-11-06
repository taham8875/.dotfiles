#!/usr/bin/env bash
# Screen recording script
# Supports: obs, kazam, simplescreenrecorder, ffmpeg

SCREENCAST_DIR="$HOME/Videos/Screencasts"
mkdir -p "$SCREENCAST_DIR"

# Check if already recording
RECORDING_FILE="/tmp/i3-screencast-recording"
if [ -f "$RECORDING_FILE" ]; then
    PID=$(cat "$RECORDING_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        # Stop recording
        kill "$PID" 2>/dev/null
        rm -f "$RECORDING_FILE"
        notify-send "Screencast" "Recording stopped" 2>/dev/null
        exit 0
    else
        rm -f "$RECORDING_FILE"
    fi
fi

FILENAME="$SCREENCAST_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4"

# Try OBS Studio (if available)
if command -v obs &> /dev/null; then
    obs &
    notify-send "Screencast" "OBS Studio opened. Use it to start recording." 2>/dev/null
    exit 0
fi

# Try ffmpeg (most common, works everywhere)
if command -v ffmpeg &> /dev/null; then
    # Get screen resolution
    SCREEN=$(xrandr | grep -oP '\d+x\d+' | head -1)
    if [ -z "$SCREEN" ]; then
        SCREEN="1920x1080"
    fi
    
    # Start recording
    ffmpeg -f x11grab -s "$SCREEN" -r 30 -i :0.0 -f pulse -ac 2 -i default -vcodec libx264 -preset ultrafast -crf 0 -threads 0 -acodec libmp3lame "$FILENAME" > /tmp/ffmpeg-screencast.log 2>&1 &
    FFMPEG_PID=$!
    echo $FFMPEG_PID > "$RECORDING_FILE"
    
    notify-send "Screencast" "Recording started. Press PrintScreen again to stop." 2>/dev/null
    exit 0
fi

# Try kazam
if command -v kazam &> /dev/null; then
    kazam &
    notify-send "Screencast" "Kazam opened. Use it to start recording." 2>/dev/null
    exit 0
fi

# Try simple-screen-recorder
if command -v simplescreenrecorder &> /dev/null; then
    simplescreenrecorder &
    notify-send "Screencast" "SimpleScreenRecorder opened. Use it to start recording." 2>/dev/null
    exit 0
fi

# If nothing is available
notify-send "Screencast Error" "No recording tool found. Please install ffmpeg, obs, kazam, or simplescreenrecorder." 2>/dev/null || \
    echo "Error: No recording tool found. Please install ffmpeg, obs, kazam, or simplescreenrecorder."
exit 1


