#!/bin/bash

# Envía la señal SIGUSR1 a todas las instancias de Alacritty
pkill -SIGUSR1 alacritty
