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

![Wallpaper](https://github.com/user-attachments/assets/49ea4250-3362-4861-858a-1d6b3ddaa7ef)
![Wallpaper1](https://github.com/user-attachments/assets/cbe62959-4e16-409e-acc0-9b4c13488e6d)
![Wallpaper2](https://github.com/user-attachments/assets/afca1b7b-1fe7-4c98-9f3f-6c156641d49b)
![Wallpaper3](https://github.com/user-attachments/assets/dde8dc83-d8d7-400c-9b51-667d58df155b)
![Wallpaper4](https://github.com/user-attachments/assets/2ff1bfb0-70aa-4614-8d22-235c0c2a7b0a)
![Wallpaper5](https://github.com/user-attachments/assets/7c389659-5246-46d1-8116-c02170458980)
![Wallpaper6](https://github.com/user-attachments/assets/7f6938e3-6a6d-4ea2-8995-7c677d5d1324)
![Wallpaper7](https://github.com/user-attachments/assets/6e21f96c-7079-45f3-8c2f-7ef36813819c)
![Wallpaper8](https://github.com/user-attachments/assets/fd7662b4-f426-47ac-99c4-8b89b33521d6)
![Wallpaper9](https://github.com/user-attachments/assets/f243965f-86f0-4c8f-9ed5-c100a7c5ab89)
![Wallpaper10](https://github.com/user-attachments/assets/cec4a850-555b-48ae-997e-4de06e1ae4df)
![Wallpaper11](https://github.com/user-attachments/assets/d9ea40d3-0dea-4adc-9767-836505c2c693)
![Wallpaper12](https://github.com/user-attachments/assets/367f4db7-9a0e-4280-91f7-1c743513c902)


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
