#!/bin/bash
# Script para obtener el color dominante de una imagen, incluyendo GIFs

# Si no se proporciona un argumento, lee la ruta de la imagen desde .current_wallpaper
if [ -z "$1" ]; then
    IMAGE_PATH=$(cat "$HOME/.current_wallpaper")
else
    IMAGE_PATH="$1"
fi

# Verifica si la imagen existe
if [ ! -f "$IMAGE_PATH" ]; then
    echo "La imagen no existe: $IMAGE_PATH" >&2
    exit 1
fi

# Verifica el formato de la imagen de manera más robusta
FORMAT=$(identify -format "%m" "$IMAGE_PATH" 2>/dev/null | head -n 1)

# Limpia el formato en caso de que haya repeticiones
FORMAT=$(echo "$FORMAT" | tr -d '[:space:]' | cut -c1-3)

# Define el comando para extraer el color dominante basado en el formato
case "$FORMAT" in
    PNG|JPE|JPG|WEB)
        # Usa ImageMagick para obtener el color dominante
        COLOR=$(magick "$IMAGE_PATH" -resize 1x1 txt:- | grep -oP '#\K[0-9A-Fa-f]{6}')
        ;;
    GIF)
        # Para GIFs, extrae el color dominante del primer frame
        COLOR=$(magick "$IMAGE_PATH[0]" -resize 1x1 txt:- | grep -oP '#\K[0-9A-Fa-f]{6}')
        ;;
    *)
        echo "Formato de imagen no soportado o error al procesar la imagen: $FORMAT" >&2
        exit 1
        ;;
esac

# Verifica si se obtuvo el color correctamente
if [ -z "$COLOR" ]; then
    echo "No se pudo obtener el color dominante. Color por defecto será negro." >&2
    COLOR="000000"
fi

echo "$COLOR"
