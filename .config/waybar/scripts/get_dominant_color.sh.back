#!/bin/bash
# Script para obtener el color dominante de una imagen

IMAGE_PATH="$1"

# Verifica si la imagen existe
if [ ! -f "$IMAGE_PATH" ]; then
    echo "La imagen no existe." >&2
    exit 1
fi

# Verifica el formato de la imagen
FORMAT=$(identify -format "%m" "$IMAGE_PATH" 2>/dev/null)

# Define el comando para extraer el color dominante basado en el formato
case "$FORMAT" in
    PNG|JPEG|JPG|WEBP)
        # Usa ImageMagick para obtener el color dominante
        COLOR=$(magick "$IMAGE_PATH" -resize 1x1 txt:- | grep -oP '#\K[0-9A-Fa-f]{6}')
        ;;
    *)
        echo "Formato de imagen no soportado o error al procesar la imagen." >&2
        exit 1
        ;;
esac

# Verifica si se obtuvo el color correctamente
if [ -z "$COLOR" ]; then
    echo "No se pudo obtener el color dominante. Color por defecto será negro." >&2
    COLOR="000000"
fi

echo "$COLOR"
