#!/bin/bash

CLIPBOARD_MANAGER="$HOME/.config/hypr/scripts/clipboard-manager.sh"

case "$1" in
    show)
        "$CLIPBOARD_MANAGER" show
        ;;
    *)
        echo ""
        ;;
esac
