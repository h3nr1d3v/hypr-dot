# Configuration Guide

This document provides detailed information on configuring your Hyprland environment, including optional wireless setup and customization of various Hyprland components.

## Table of Contents

- [Configuration Guide](#configuration-guide)
  - [Table of Contents](#table-of-contents)
  - [Wireless Setup (Optional)](#wireless-setup-optional)
  - [Hyprland Configuration](#hyprland-configuration)
    - [Main Configuration File](#main-configuration-file)
    - [Animations](#animations)
    - [Startup Commands](#startup-commands)
    - [General Settings](#general-settings)
    - [Input Devices](#input-devices)
    - [Keybindings](#keybindings)
    - [Monitor Setup](#monitor-setup)
    - [Window Rules](#window-rules)
  - [Lock Screen Configuration](#lock-screen-configuration)

## Wireless Setup (Optional)

If you prefer to use iwd instead of NetworkManager for wireless connectivity, follow these steps:

1. Install the required packages:
   ```bash
   sudo pacman -S iwd dhcpcd
    ```

2. Enable and start the services:

```shellscript
sudo systemctl enable --now iwd
sudo systemctl enable --now dhcpcd
```


3. Disable and stop the NetworkManager service:

```shellscript
sudo systemctl disable --now NetworkManager
```


4. Configure your wireless connection using `iwctl`:

```shellscript
iwctl
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
[iwd]# station <device> show
```

## Hyprland Configuration

Hyprland uses a modular configuration system with multiple .conf files located in the `~/.config/hypr/` directory.

### Main Configuration File

The main configuration file is `~/.config/hypr/hyprland.conf`. It sources other configuration files:

```plaintext
source = ~/.config/hypr/animations.conf
source = ~/.config/hypr/colors.conf
source = ~/.config/hypr/exec.conf
source = ~/.config/hypr/general.conf
source = ~/.config/hypr/input.conf
source = ~/.config/hypr/keybinds.conf
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/windowrules.conf
```

### Animations

Edit `~/.config/hypr/animations.conf` to customize animation settings. Example:

```plaintext
animations {
    enabled = true
    bezier = overshot, 0.05, 0.9, 0.1, 1.1
    animation = windows, 1, 7, overshot
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}
```

### Startup Commands

Edit `~/.config/hypr/exec.conf` to manage startup applications and environment variables. Example:

```plaintext
exec-once = waybar
exec-once = dunst
exec-once = swww-daemon
exec = ~/.config/hypr/scripts/batterynotify.sh

env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = GDK_BACKEND,wayland
```

### General Settings

Edit `~/.config/hypr/general.conf` to adjust general appearance and behavior. Example:

```plaintext
general {
    gaps_in = 3
    gaps_out = 8
    border_size = 2
    layout = dwindle
}

decoration {
    rounding = 10
    drop_shadow = false
    blur {
        enabled = yes
        size = 6
        passes = 3
    }
}
```

### Input Devices

Edit `~/.config/hypr/input.conf` to configure input devices. Example:

```plaintext
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = yes
    }
    sensitivity = 1.0
}
```

### Keybindings

Edit `~/.config/hypr/keybinds.conf` to set up custom keybindings. Example:

```plaintext
$mainMod = SUPER

bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, wofi --show drun
bind = $mainMod, P, pseudo,
```

### Monitor Setup

Edit `~/.config/hypr/monitors.conf` to configure your displays. Example:

```plaintext
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
```

### Window Rules

Edit `~/.config/hypr/windowrules.conf` to set rules for specific applications. Example:

```plaintext
windowrulev2 = opacity 0.8 0.8,class:^(kitty)$
windowrulev2 = float,class:^(pavucontrol)$
windowrulev2 = workspace 2 silent,class:^(firefox)$
```

## Lock Screen Configuration

Edit `~/.config/hypr/hyprlock.conf` to customize your lock screen. Example:

```plaintext
background {
    monitor =
    path = /path/to/your/wallpaper.png
    blur_passes = 4
}

input-field {
    monitor =
    size = 300, 50
    outline_thickness = 3
    dots_size = 0.2
    dots_spacing = 0.15
    outer_color = rgb(242, 139, 130)
    inner_color = rgb(0, 0, 0, 0.5)
    font_color = rgb(255, 255, 255)
    fade_on_empty = true
    placeholder_text = <span foreground="##ffffff55">Password...</span>
    hide_input = false
    position = 0, 50
    halign = center
    valign = center
}
```

Remember to reload Hyprland after making changes to the configuration files:

```shellscript
hyprctl reload
```

For more detailed information on each configuration option, refer to the [Hyprland documentation](https://wiki.hyprland.org/).
