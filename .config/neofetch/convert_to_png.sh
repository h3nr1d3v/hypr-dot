#!/bin/bash

input_file="${1:-$(cat $HOME/.current_wallpaper 2>/dev/null)}"

if [ -z "$input_file" ]; then
    echo "Error: No se pudo obtener el archivo de entrada" >&2
    exit 1
fi

filename=$(basename "$input_file")
output_dir="$HOME/.cache/neofetch/converted_wallpapers"
output_file="$output_dir/${filename%.*}.png"

mkdir -p "$output_dir"

if [[ "$input_file" != *.png ]]; then
    if command -v magick &> /dev/null; then
        magick "$input_file" "$output_file"
    elif command -v convert &> /dev/null; then
        convert "$input_file" "$output_file"
    else
        echo "Error: No se encontró ImageMagick" >&2
        exit 1
    fi
    echo "$output_file"
else
    echo "$input_file"
fi
