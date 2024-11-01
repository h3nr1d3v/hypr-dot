#!/bin/bash

# Function to print colored output
print_color() {
    COLOR=$1
    MESSAGE=$2
    echo -e "\e[${COLOR}m${MESSAGE}\e[0m"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to find Firefox profile directory
find_firefox_profile() {
    FIREFOX_DIR="$HOME/.mozilla/firefox"
    if [ -d "$FIREFOX_DIR" ]; then
        PROFILE_INI="$FIREFOX_DIR/profiles.ini"
        if [ -f "$PROFILE_INI" ]; then
            DEFAULT_PROFILE=$(grep -E "^Path=" "$PROFILE_INI" | grep "default-release" | cut -d'=' -f2)
            if [ -n "$DEFAULT_PROFILE" ]; then
                echo "$FIREFOX_DIR/$DEFAULT_PROFILE"
                return 0
            fi
        fi
    fi
    return 1
}

# Note: This script should be run from the root of the cloned repository
# If you haven't cloned the repository yet, do so with:
# git clone https://github.com/h3nr1d3v/hypr-dot.git
# cd hypr-dot
# Then run this script with: ./install.sh

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_color "31" "Please run this script as a normal user, not as root."
    exit 1
fi

# Install Pacman packages
print_color "34" "Installing Pacman packages..."
sudo pacman -S --noconfirm alacritty bpytop hyprland brightnessctl kitty libpng libjpeg-turbo imagemagick gawk grep dunst ripgrep vim neofetch neovim ffmpeg v4l-utils python python-pip

# Check if yay is installed, if not, install it
if ! command_exists yay; then
    print_color "34" "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install AUR packages
print_color "34" "Installing AUR packages..."
yay -S --noconfirm cmus cmatrix-git dunst ranger mpv swww swaync sway-lock sway-bg waybar flameshot-git pactl pamixer pipes.sh tty-clock


# Create necessary directories
print_color "34" "Creating necessary directories..."
mkdir -p ~/.config ~/.local ~/Documents/Home ~/Pictures/Wallpapers ~/.local/share/icons

# Copy configuration files
print_color "34" "Copying configuration files..."
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/
cp -r Documents/Home/* ~/Documents/Home/
cp -r Pictures/Wallpapers/* ~/Pictures/Wallpapers/
cp -r usr/share/icons/* ~/.local/share/icons/

# Find and copy Firefox configuration
FIREFOX_PROFILE=$(find_firefox_profile)
if [ -n "$FIREFOX_PROFILE" ]; then
    print_color "34" "Copying Firefox configuration..."
    mkdir -p "$FIREFOX_PROFILE/chrome"
    cp -r .mozilla/firefox/*/chrome/* "$FIREFOX_PROFILE/chrome/"
else
    print_color "33" "Firefox profile not found. Skipping Firefox configuration."
fi

# Set executable permissions for scripts
print_color "34" "Setting executable permissions for scripts..."
chmod +x ~/.config/hypr/scripts/*
chmod +x ~/.config/waybar/scripts/*
chmod +x ~/.local/bin/*

# Update font cache
print_color "34" "Updating font cache..."
fc-cache -fv

# Install Python packages
print_color "34" "Installing Python packages..."
pip install --break-system-packages --user colorama vlc yt_dlp tqdm youtubesearchpython

# Reload Hyprland configuration
print_color "34" "Reloading Hyprland configuration..."
hyprctl reload

print_color "32" "Installation complete!"
print_color "33" "Please log out, select Hyprland as your window manager at the login screen, and log back in."
print_color "33" "After logging in, open a terminal and run: neofetch && hyprctl version"
