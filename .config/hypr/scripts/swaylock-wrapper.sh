#!/bin/bash

# Rutas a los archivos de sonido
LOCK_SOUND="~/Music/sounds/lock.wav"
UNLOCK_SOUND="~/Music/sounds/unlock.wav"
WRONG_SOUND="~/Music/sounds/wrong.wav"

# Rutas de las imágenes
CLEAR_IMAGE="~/Pictures/Wallpapers/imagen_061.png"
BLUR_IMAGE="~/Pictures/Wallpapers/imagen_061_blur.png"

# Función para reproducir sonido
play_sound() {
    paplay "$1"
}

# Reproducir sonido de bloqueo
play_sound "$LOCK_SOUND"

# Ejecutar swaylock con la imagen clara
swaylock -f -i "$CLEAR_IMAGE" &

