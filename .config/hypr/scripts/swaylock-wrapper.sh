#!/bin/bash

# Rutas a los archivos de sonido
LOCK_SOUND="/home/h3nr1d3v/Music/sounds/lock.wav"
UNLOCK_SOUND="/home/h3nr1d3v/Music/sounds/unlock.wav"
WRONG_SOUND="/home/h3nr1d3v/Music/sounds/wrong.wav"

# Rutas de las imágenes
CLEAR_IMAGE="/home/h3nr1d3v/Pictures/Wallpapers/imagen_061.png"
BLUR_IMAGE="/home/h3nr1d3v/Pictures/Wallpapers/imagen_061_blur.png"

# Función para reproducir sonido
play_sound() {
    paplay "$1"
}

# Reproducir sonido de bloqueo
play_sound "$LOCK_SOUND"

# Ejecutar swaylock con la imagen clara
swaylock -f -i "$CLEAR_IMAGE" &

