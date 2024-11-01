# 📦 Installation

## Automated Installation

For a quick and easy setup, you can use the provided installation script:

1. Clone the repository:

```bash
git clone https://github.com/h3nr1d3v/hypr-dot.git
cd hypr-dot
```

2. Run the installation script:

```bash
./install.sh
```

This script will automatically install all necessary packages, copy configuration files, and set up your Hyprland environment.

## Manual Installation

If you prefer to install manually or want to understand the process better, follow these steps:

### Prerequisites

#### Pacman Packages

Install the following packages using pacman:

```bash
sudo pacman -S alacritty bpytop hyprland brightnessctl kitty libpng libjpeg-turbo imagemagick gawk grep dunst ripgrep vim neofetch neovim ffmpeg v4l-utils python python-pip
```

#### AUR Packages

Install the following packages using your AUR helper (yay):

```bash
yay -S cmus cmatrix-git dunst ranger mpv swww swaync sway-lock sway-bg waybar flameshot-git pactl pamixer pipes.sh tty-clock
```

### Installation Steps

1. Clone the repository:

```bash
git clone https://github.com/h3nr1d3v/hypr-dot.git
cd hypr-dot
```

2. Create necessary directories (if they don't exist):

```bash
mkdir -p ~/.config ~/.local ~/.mozilla/chrome ~/Documents/Home ~/Pictures/Wallpapers ~/.local/share/icons
```

3. Copy configuration files:

```bash
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

### Post-Installation Setup

1. Set executable permissions for scripts:

```bash
chmod +x ~/.config/hypr/scripts/*
chmod +x ~/.config/waybar/scripts/*
chmod +x ~/.local/bin/*
```

2. Update font cache:

```bash
fc-cache -fv
```

3. Install required Python packages:

```bash
pip install --break-system-packages --user colorama vlc yt_dlp tqdm youtubesearchpython
```

4. Reload Hyprland configuration:

```bash
hyprctl reload
```

## Verification

To verify your installation:

1. Log out of your current session
2. Select Hyprland as your window manager at the login screen
3. Log in
4. Open a terminal and run:

```bash
neofetch
hyprctl version
```

## Directory Structure

Your configuration should now have the following structure:

```plaintext
└── $HOME
    ├── .config/          # Configuration files
    ├── .local/           # Local files and scripts
    ├── .mozilla/chrome   # Firefox/Chrome themes
    ├── Documents/Home    # Document templates
    ├── Pictures/Wallpapers
    └── .local/share/icons
```
