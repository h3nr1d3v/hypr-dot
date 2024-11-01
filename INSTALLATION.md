## 📦 Installation

## Prerequisites

### Pacman Packages

Install the following packages using pacman:

```bash
sudo pacman -S alacritty bpytop hyprland brightnessctl kitty libpng libjpeg-turbo imagemagick  gawk grep dunst ripgrep vim neofetch neovim ffmpeg v4l-utils
```
### Aur Packages
```bash
yay -S cmus cmatrix-git  dunst ranger mpv swww swaync sway-lock sway-bg waybar  flameshot-git pactl pamixer pipes.sh tty-clock 
```

### Quick Setup

1. Clone the repository:


```shellscript
git clone https://github.com/h3nr1d3v/hypr-dot.git
cd hypr-dot
```
### Required Packages (AUR)

Install the following packages using your AUR helper (yay):

```shellscript
yay -S cmus cmatrix-git dunst ranger mpv swww swaync sway-lock sway-bg waybar flameshot-git pactl pamixer pipes.sh tty-clock
```

## Installation Steps

1. Clone the repository:


```shellscript
git clone https://github.com/h3nr1d3v/hypr-dot.git
cd hypr-dot
```

2. Create necessary directories (if they don't exist):


```shellscript
mkdir -p ~/.config
mkdir -p ~/.local
mkdir -p ~/.mozilla/chrome
mkdir -p ~/Documents/Home
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/.local/share/icons
```

3. Copy configuration files:


```shellscript
# Copy .config files
cp -r .config/* ~/.config/

# Copy .local files
cp -r .local/* ~/.local/

# Copy mozilla/chrome files
cp -r .mozilla/chrome/* ~/.mozilla/chrome/

# Copy Documents
cp -r Documents/Home/* ~/Documents/Home/

# Copy Wallpapers
cp -r Pictures/Wallpapers/* ~/Pictures/Wallpapers/

# Copy icons
cp -r usr/share/icons/* ~/.local/share/icons/
```

## Post-Installation Setup

1. Set executable permissions for scripts:


```shellscript
chmod +x ~/.config/hypr/scripts/*
chmod +x ~/.config/waybar/scripts/*
chmod +x ~/.local/bin/*
```

2. Update font cache:


```shellscript
fc-cache -fv
```

3. Reload Hyprland configuration:


```shellscript
hyprctl reload
```

## Verification

To verify your installation:

1. Log out of your current session
2. Select Hyprland as your window manager at the login screen
3. Log in
4. Open a terminal and run:


```shellscript
neofetch
hyprctl version
```

## Directory Structure

Your configuration should now have the following structure:

```plaintext
└── $HOME
    ├── .config/          # Configuration files
    ├── .local/          # Local files and scripts
    ├── .mozilla/chrome  # Firefox/Chrome themes
    ├── Documents/Home   # Document templates
    ├── Pictures/Wallpapers
    └── .local/share/icons
```