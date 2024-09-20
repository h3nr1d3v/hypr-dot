#!/bin/bash
# Location: ~/.config/waybar/scripts/volumecontrol.sh

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "Muted" || echo "Unmuted"
}

case "$1" in
    -o) pactl set-sink-mute @DEFAULT_SINK@ toggle 
        dunstify "Volume: $(get_mute)";;
    -i) pactl set-sink-volume @DEFAULT_SINK@ +5% 
        dunstify "Volume: $(get_volume)%";;
    -d) pactl set-sink-volume @DEFAULT_SINK@ -5% 
        dunstify "Volume: $(get_volume)%";;
    -m) pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
    *) echo "Usage: $0 {-o|-i|-d|-m}" ;;
esac
