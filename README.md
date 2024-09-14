# Arch Linux + Hyprland Configuration

Welcome to my personal Arch Linux configuration featuring Hyprland! This repository contains my dotfiles and setup instructions for a customized Arch Linux environment with Hyprland as the window manager.

## Table of Contents

- [Preview](#preview)
- [Installation](#installation)
- [Required Packages](#required-packages)
- [Wireless Setup (Optional)](#wireless-setup-optional)
- [Usage](#usage)
- [Key Shortcuts](#key-shortcuts)
- [Contributing](#contributing)
- [License](#license)

## Preview

![Screenshot](https://github.com/user-attachments/assets/6596d915-5a5d-44b4-953c-1de6ffec7215)
![Screenshot1](https://github.com/user-attachments/assets/6977c7bf-326f-4f02-9603-5a1cbd551cac)
![Screenshot2](https://github.com/user-attachments/assets/3879c72e-e97f-42fd-a9e6-a04394726c03)
![Screenshot3](https://github.com/user-attachments/assets/800bd5b3-486e-43c2-afbf-cea78e1cff60)
![Screenshot4](https://github.com/user-attachments/assets/59a7c441-91a9-4678-8e6d-959771bb21ed)
![Screenshot5](https://github.com/user-attachments/assets/6202fe7f-785e-4dd1-ac7b-93c9d010c6fc)
![Screenshot6](https://github.com/user-attachments/assets/d275d0ad-2e5a-4596-a194-e05dbd900867)
![Screenshot7](https://github.com/user-attachments/assets/88fdf57d-cd98-4422-addb-1de3230da852)
![Screenshot8](https://github.com/user-attachments/assets/11ab1007-a8bf-4944-8bdd-017a649fe2ef)
![Screenshot9](https://github.com/user-attachments/assets/a3d59ff6-809f-45d1-83e0-4d0e4344e052)

## Installation

1. Clone this repository:

```bash
git clone https://github.com/h3nr1d3v/hypr-dot.git 
```

2. Change to the repository directory:

```bash
cd hypr-dot
```

3. Copy the configuration files to your home directory:

```bash
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/share/
cp -r Pictures/* ~/Pictures/
```

## Required Packages:
```bash
### Pacman Packages

Install the following packages using pacman:

```bash
sudo pacman -S hyprland brightnessctl libpng libjpeg-turbo imagemagick gawk grep dunst ripgrep vim neovim ffmpeg v4l-utils

### AUR packages
```bash
yay -S dunst ranger swww waybar sway-bg flameshot-git pactl pamixer
```
## Wireless Setup (Optional)
If you prefer to use `iwd` instead of NetworkManager for wireless connectivity, follow these steps:

1. Install the required packages:

```bash
sudo pacman -S iwd dhcpcd

2. Enable and start the services:

```bash
sudo systemctl enable --now iwd
sudo systemctl enable --now dhcpcd

3. Disable and stop the NetworkManager service:

```bash
sudo systemctl disable --now NetworkManager

4. Configure your wireless connection using `iwctl`:

```bash
iwctl
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
```

## Usage
After installation and setup, log out and choose Hyprland as your window manager at the login screen. Your customized environment should now be ready to use!

## Key Shortcuts

Here are some of the key shortcuts defined in the Hyprland configuration:

### Window/Session Management
- `SUPER + Q`: Kill active window
- `ALT + F4`: Kill active window
- `SUPER + X`: Exit Hyprland session
- `SUPER + W`: Toggle floating for active window
- `SUPER + G`: Toggle group
- `ALT + Enter`: Toggle fullscreen
- `SUPER + SHIFT + R`: Reload Waybar

### Application Shortcuts
- `SUPER + T`: Open Alacritty terminal
- `SUPER + E`: Open Dolphin file manager
- `SUPER + F`: Open Firefox
- `SUPER + D`: Open Discord
- `SUPER + O`: Open OBS
- `SUPER + S`: Open Spotify
- `SUPER + R`: Open Rofi launcher
- `SUPER + C`: Open Visual Studio Code

### Audio Control
- `XF86AudioLowerVolume`: Decrease volume
- `XF86AudioRaiseVolume`: Increase volume
- `XF86AudioMute`: Mute/unmute audio
- `F11`: Toggle microphone mute
- `XF86AudioPlay`: Play/pause media
- `XF86AudioNext`: Next track
- `XF86AudioPrev`: Previous track

### Brightness Control
- `XF86MonBrightnessDown`: Decrease brightness
- `XF86MonBrightnessUp`: Increase brightness

### Screenshot
- `Print`: Take a screenshot (using Flameshot)

### Window Focus
- `SUPER + Arrow keys`: Move focus
- `ALT + Tab`: Move focus

### Workspace Management
- `SUPER + (1-5)`: Switch to workspace 1-5
- `SUPER + SHIFT + (1-3)`: Move active window to workspace 1-3
- `SUPER + Mouse Wheel`: Scroll through workspaces

### Window Movement/Resizing
- `SUPER + SHIFT + Arrow keys`: Resize active window
- `SUPER + Mouse Left Click`: Move window
- `SUPER + Mouse Right Click`: Resize window

### Special Functions
- `SUPER + ALT + S`: Move window to special workspace
- `SUPER + Z`: Toggle special workspace
- `SUPER + J`: Toggle split (dwindle layout)

Remember to customize these shortcuts according to your preferences in the `~/.config/hypr/hyprland.conf` file.

## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request if you have any suggestions or improvements.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
