#!/bin/bash
# Location: ~/.config/waybar/scripts/volumecontrol.sh

case "$1" in
    -o) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    -i) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    -d) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    -m) pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
    *) echo "Usage: $0 {-o|-i|-d|-m}" ;;
esac
