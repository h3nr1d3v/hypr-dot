#!/bin/bash
# Location: ~/.config/waybar/scripts/brightnesscontrol.sh

get_brightness() {
    brightnessctl -m | cut -d',' -f4 | tr -d '%'
}

case "$1" in
    i) brightnessctl set +5% 
       dunstify "Brightness: $(get_brightness)%";;
    d) brightnessctl set 5%- 
       dunstify "Brightness: $(get_brightness)%";;
    *) echo "Usage: $0 {i|d}" ;;
esac
