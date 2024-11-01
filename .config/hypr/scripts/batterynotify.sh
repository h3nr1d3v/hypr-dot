#!/bin/bash

# Check if the system is a laptop
is_laptop() {
    if [ -d /sys/class/power_supply/ ]; then
        for supply in /sys/class/power_supply/*; do
            if [ -e "$supply/type" ]; then
                type=$(cat "$supply/type")
                if [ "$type" == "Battery" ]; then
                    return 0  # It's a laptop
                fi
            fi
        done
    fi
    return 1  # It's not a laptop
}

if is_laptop; then
    # Initialize variables to track last notified state
    last_low_notified=0
    last_charged_notified=0

    while true; do
        battery_status=$(cat /sys/class/power_supply/BAT0/status)
        battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)

        if [ "$battery_status" == "Discharging" ] && [ "$battery_percentage" -le 20 ] && [ "$last_low_notified" -eq 0 ]; then
            dunstify -u CRITICAL "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
            last_low_notified=1
            last_charged_notified=0
        fi

        if [ "$battery_status" == "Charging" ] && [ "$battery_percentage" -ge 80 ] && [ "$last_charged_notified" -eq 0 ]; then
            dunstify -u NORMAL "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger."
            last_charged_notified=1
            last_low_notified=0
        fi

        # Reset notifications if battery status changes
        if [ "$battery_status" == "Charging" ] && [ "$battery_percentage" -gt 20 ]; then
            last_low_notified=0
        fi

        if [ "$battery_status" == "Discharging" ] && [ "$battery_percentage" -lt 80 ]; then
            last_charged_notified=0
        fi

        sleep 300  # Sleep for 5 minutes before checking again
    done
fi
