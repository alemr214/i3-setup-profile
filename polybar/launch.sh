#!/bin/bash
killall -q polybar
# Wait for polybar to exit, with timeout
TIMEOUT=10
COUNT=0
while pgrep -x polybar >/dev/null; do
    sleep 1
    COUNT=$((COUNT+1))
    if [ "$COUNT" -ge "$TIMEOUT" ]; then
        echo "polybar did not exit after $TIMEOUT seconds, sending SIGKILL..."
        pkill -9 -x polybar
        # Wait a bit more after SIGKILL
        sleep 2
        if pgrep -x polybar >/dev/null; then
            echo "polybar still running after SIGKILL, aborting launch."
            exit 1
        fi
        break
    fi
done
polybar -c ~/.config/polybar/config.ini main >>/tmp/polybar.log 2>&1 &
