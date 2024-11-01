#!/bin/bash

CLIPBOARD_HISTORY="$HOME/.cache/clipboard-history"

# Ensure the history file exists
touch "$CLIPBOARD_HISTORY"

# Function to add current clipboard content to history
add_to_history() {
    local content
    content=$(wl-paste)
    if [ -n "$content" ]; then
        echo "$content" >> "$CLIPBOARD_HISTORY"
        tail -n 100 "$CLIPBOARD_HISTORY" > "$CLIPBOARD_HISTORY.tmp" && mv "$CLIPBOARD_HISTORY.tmp" "$CLIPBOARD_HISTORY"
    fi
}

# Main loop
while true; do
    clipnotify
    add_to_history
done
