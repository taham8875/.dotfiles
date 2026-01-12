#!/usr/bin/env bash
# Screen recording script with area selection using slop
# Supports: ffmpeg with slop for area selection

SCREENCAST_DIR="$HOME/Videos/Screencasts"
mkdir -p "$SCREENCAST_DIR"

# Check if already recording
RECORDING_FILE="/tmp/i3-screencast-recording"
if [ -f "$RECORDING_FILE" ]; then
    PID=$(cat "$RECORDING_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        # Stop recording gracefully with SIGINT (same as Ctrl+C)
        # This allows ffmpeg to properly flush buffers and finalize the video file
        kill -INT "$PID" 2>/dev/null

        # Wait for graceful shutdown (max 5 seconds)
        WAIT_COUNT=0
        while kill -0 "$PID" 2>/dev/null && [ $WAIT_COUNT -lt 50 ]; do
            sleep 0.1
            WAIT_COUNT=$((WAIT_COUNT + 1))
        done

        # Force kill if still running
        if kill -0 "$PID" 2>/dev/null; then
            kill -KILL "$PID" 2>/dev/null
            notify-send "Screencast" "Recording force-stopped (timeout). Video may be incomplete." 2>/dev/null
        else
            # Find the most recent recording
            LATEST_FILE=$(ls -t "$SCREENCAST_DIR"/screencast-*.mp4 2>/dev/null | head -1)
            if [ -n "$LATEST_FILE" ]; then
                notify-send "Screencast" "Recording stopped successfully.\nSaved: $(basename "$LATEST_FILE")" 2>/dev/null
            else
                notify-send "Screencast" "Recording stopped. Saved to $SCREENCAST_DIR" 2>/dev/null
            fi
        fi

        rm -f "$RECORDING_FILE"
        exit 0
    else
        rm -f "$RECORDING_FILE"
    fi
fi

# Cleanup function for abnormal termination only
cleanup_on_interrupt() {
    if [ -n "$FFMPEG_PID" ]; then
        kill -INT "$FFMPEG_PID" 2>/dev/null
        rm -f "$RECORDING_FILE" 2>/dev/null
    fi
}
# Only trap INT and TERM (user interrupt), NOT EXIT (normal completion)
trap cleanup_on_interrupt INT TERM

# Check for required tools
if ! command -v ffmpeg &> /dev/null; then
    notify-send "Screencast Error" "ffmpeg is not installed. Please install ffmpeg." 2>/dev/null || \
        echo "Error: ffmpeg is not installed."
    exit 1
fi

if ! command -v slop &> /dev/null; then
    notify-send "Screencast Error" "slop is not installed. Please install slop for area selection." 2>/dev/null || \
        echo "Error: slop is not installed."
    exit 1
fi

# Get area selection using slop
# Format: "X Y W H" (x position, y position, width, height)
# Color: dark gray with 10% opacity for subtle, non-intrusive overlay
AREA=$(slop -f "%x %y %w %h" -b 2 -c 0.2,0.2,0.2,0.1 -l -q)

# Check if user cancelled selection (slop returns empty string on cancel)
if [ -z "$AREA" ]; then
    # User cancelled, exit silently
    exit 0
fi

# Parse area coordinates
X=$(echo "$AREA" | awk '{print $1}')
Y=$(echo "$AREA" | awk '{print $2}')
W=$(echo "$AREA" | awk '{print $3}')
H=$(echo "$AREA" | awk '{print $4}')

# Round coordinates to integers (ffmpeg doesn't accept decimals)
X=$(printf "%.0f" "$X")
Y=$(printf "%.0f" "$Y")
W=$(printf "%.0f" "$W")
H=$(printf "%.0f" "$H")

# Ensure width and height are even (libx264 requirement)
# If odd, subtract 1 to make even
[ $((W % 2)) -eq 1 ] && W=$((W - 1))
[ $((H % 2)) -eq 1 ] && H=$((H - 1))

# Validate coordinates
if [ -z "$X" ] || [ -z "$Y" ] || [ -z "$W" ] || [ -z "$H" ]; then
    notify-send "Screencast Error" "Failed to get area selection coordinates." 2>/dev/null || \
        echo "Error: Failed to get area selection coordinates."
    exit 1
fi

# Ensure minimum size
if [ "$W" -lt 10 ] || [ "$H" -lt 10 ]; then
    notify-send "Screencast Error" "Selected area is too small (minimum 10x10 pixels)." 2>/dev/null || \
        echo "Error: Selected area is too small."
    exit 1
fi

FILENAME="$SCREENCAST_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4"

# Auto-detect current display (defaults to :0 if not set)
CURRENT_DISPLAY="${DISPLAY:-:0}"

# Get audio source (monitor of default sink)
# First, try to get the default sink's monitor source
DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null)
if [ -n "$DEFAULT_SINK" ]; then
    # Monitor sources follow pattern: <sink_name>.monitor
    AUDIO_SOURCE="${DEFAULT_SINK}.monitor"

    # Verify this monitor source actually exists
    if ! pactl list sources short 2>/dev/null | grep -q "^[0-9]*[[:space:]]*${AUDIO_SOURCE}"; then
        # Fallback: Find first running monitor source
        AUDIO_SOURCE=$(pactl list sources short 2>/dev/null | grep -i "monitor" | grep "RUNNING" | head -1 | awk '{print $2}')

        # If no running monitor, get any monitor
        if [ -z "$AUDIO_SOURCE" ]; then
            AUDIO_SOURCE=$(pactl list sources short 2>/dev/null | grep -i "monitor" | head -1 | awk '{print $2}')
        fi
    fi
fi

# Final fallback if everything fails
if [ -z "$AUDIO_SOURCE" ]; then
    AUDIO_SOURCE="default"
fi

# Clear previous log and add structured logging
echo "=== Screencast started at $(date) ===" > /tmp/ffmpeg-screencast.log
echo "Area: ${W}x${H} at position (${X}, ${Y})" >> /tmp/ffmpeg-screencast.log
echo "Display: ${CURRENT_DISPLAY}" >> /tmp/ffmpeg-screencast.log
echo "Audio source: ${AUDIO_SOURCE}" >> /tmp/ffmpeg-screencast.log
echo "Output file: ${FILENAME}" >> /tmp/ffmpeg-screencast.log
echo "======================================" >> /tmp/ffmpeg-screencast.log

# Start recording with area selection
# Modern x11grab syntax using explicit options
ffmpeg -f x11grab \
       -video_size "${W}x${H}" \
       -grab_x "${X}" \
       -grab_y "${Y}" \
       -framerate 30 \
       -i "${CURRENT_DISPLAY}" \
       -f pulse -ac 2 -i "$AUDIO_SOURCE" \
       -vcodec libx264 -preset medium -crf 23 \
       -pix_fmt yuv420p \
       -acodec aac -b:a 192k \
       -threads 0 \
       "$FILENAME" >> /tmp/ffmpeg-screencast.log 2>&1 &
FFMPEG_PID=$!

# Verify ffmpeg actually started
sleep 0.5  # Give ffmpeg time to initialize

if ! kill -0 "$FFMPEG_PID" 2>/dev/null; then
    # FFmpeg process died immediately
    rm -f "$RECORDING_FILE" 2>/dev/null

    # Try to extract error from log
    ERROR_MSG=$(tail -5 /tmp/ffmpeg-screencast.log 2>/dev/null | grep -i "error\|cannot\|failed" | head -1)
    if [ -n "$ERROR_MSG" ]; then
        notify-send "Screencast Error" "FFmpeg failed: $ERROR_MSG\nCheck /tmp/ffmpeg-screencast.log for details" 2>/dev/null
    else
        notify-send "Screencast Error" "FFmpeg failed to start. Check /tmp/ffmpeg-screencast.log for details." 2>/dev/null
    fi
    exit 1
fi

# FFmpeg started successfully - write PID file immediately
echo $FFMPEG_PID > "$RECORDING_FILE"

# Check for early errors in log
sleep 0.5
if grep -qi "error\|cannot open display\|invalid" /tmp/ffmpeg-screencast.log 2>/dev/null; then
    ERROR_MSG=$(tail -10 /tmp/ffmpeg-screencast.log | grep -i "error\|cannot\|invalid" | head -1)
    kill "$FFMPEG_PID" 2>/dev/null
    rm -f "$RECORDING_FILE" 2>/dev/null
    notify-send "Screencast Error" "Recording failed: $ERROR_MSG" 2>/dev/null
    exit 1
fi

notify-send "Screencast" "Recording started (${W}x${H}@30fps)\nSaving to: $(basename "$FILENAME")\nPress Ctrl+PrintScreen again to stop." 2>/dev/null
exit 0
