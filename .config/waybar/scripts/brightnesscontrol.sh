#!/bin/bash

case "$1" in
    i) brightnessctl set +5% ;;
    d) brightnessctl set 5%- ;;
    *) echo "Usage: $0 {i|d}" ;;
esac

