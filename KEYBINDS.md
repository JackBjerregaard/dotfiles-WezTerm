# Keybind Cheatsheet

This file documents the cross-platform window-management model used by these dotfiles.

## Modifier Model

| Role | macOS / yabai + skhd | Linux / Hyprland |
|------|-----------------------|------------------|
| Main window-manager modifier | `alt` / Option | `Super` |
| Move/modify window modifier | `hyper` = `ctrl + alt + cmd` | `Super + Shift` |
| Numbered workspace focus | `ctrl + 1..9` | `Super + 1..9` |
| Extra monitor layer | Mostly unused on laptop | `Super + Ctrl` |

Notes:

- macOS `alt` is treated like Linux `Super` for app launching, focus, and workspace navigation.
- macOS `hyper` is treated like Linux `Super + Shift` for moving windows and workspaces.
- macOS numbered Spaces stay on `ctrl + 1..9` because `alt + number` can collide with normal symbol entry, especially on non-US keyboard layouts.
- macOS Spaces and Hyprland workspaces are the same workflow concept: virtual desktops.
- yabai displays and Hyprland monitors are the same hardware concept: physical screens.

## Cross-Platform Core

| Behavior | macOS | Linux |
|----------|-------|-------|
| Open terminal | `alt + return` | `Super + return` |
| Open browser | `alt + b` | `Super + b` |
| Open YouTube in Brave | `alt + y` | `Super + y` |
| Close active window | `alt + q` or native app shortcuts | `Super + q` |
| Close all windows | Native app/session shortcuts | `Super + Shift + q` |
| Focus window left/down/up/right | `alt + h/j/k/l` | `Super + h/j/k/l` |
| Move/swap window left/up/right | `hyper + h/k/l` | `Super + Shift + h/k/l` |
| Move/swap window down | `hyper + j` | Replaced by Linux split toggle |
| Rotate/swap split layout | `hyper + r` | `Super + Shift + r` |
| Previous/next workspace | `alt + p/n` | `Super + p/n` |
| Focus numbered workspace | `ctrl + 1..9` | `Super + 1..9` |
| Move window to numbered workspace | `hyper + 1..9` | `Super + Shift + 1..9` |
| Move window previous/next workspace | `hyper + p/n` | `Super + Shift + p/n` |
| Toggle native fullscreen | `hyper + f` | `Super + f` |
| Toggle tiling maximize | `hyper + m` | `Super + m` |
| Toggle floating | `hyper + t` | `Super + v` |
| Minimize to scratchpad | Native minimize | `Super + -` |
| Show minimized scratchpad | Mission Control/Dock | `Super + Shift + -` |
| Restore minimized window | Native unminimize | `Super + Ctrl + -` |

## Linux / Hyprland

Managed config: `hypr/.config/hypr/hyprland.conf`, stowed to `~/.config/hypr/hyprland.conf`.

### Applications

| Key | Action |
|-----|--------|
| `Super + return` | Open WezTerm |
| `Super + d` | Open Rofi app launcher |
| `Super + b` | Open Chrome |
| `Super + y` | Open YouTube in Brave |

### Windows

| Key | Action |
|-----|--------|
| `Super + q` | Close active window |
| `Super + Shift + q` | Safely ask all applications to close |
| `Super + f` | Native fullscreen active window |
| `Super + m` | Tiling maximize active window |
| `Super + v` | Toggle floating |
| `Super + -` | Minimize active window to the hidden `special:minimized` workspace |
| `Super + Shift + -` | Show or hide the minimized scratchpad workspace |
| `Super + Ctrl + -` | Restore the focused minimized window to the current normal workspace |
| `Super + Shift + Escape` | Exit Hyprland |
| `Super + Shift + c` | Dismiss all notifications |

### Tile Focus And Movement

| Key | Action |
|-----|--------|
| `Super + h` | Focus left |
| `Super + j` | Focus down |
| `Super + k` | Focus up |
| `Super + l` | Focus right |
| `Super + Shift + h` | Move active window left |
| `Super + Shift + j` | Toggle Dwindle split direction for the focused part of the layout |
| `Super + Shift + k` | Move active window up |
| `Super + Shift + l` | Move active window right |
| `Super + Shift + r` | Swap the two halves of the focused Dwindle split |

### Workspaces

| Key | Action |
|-----|--------|
| `Super + 1..9` | Focus workspace 1..9 |
| `Super + p` | Previous workspace |
| `Super + n` | Next workspace |
| `Super + Shift + 1..9` | Move active window to workspace 1..9 |
| `Super + Shift + p` | Move active window to previous workspace |
| `Super + Shift + n` | Move active window to next workspace |

### Monitors

These are Linux-focused because the Mac setup is normally used on a single laptop display.

| Key | Action |
|-----|--------|
| `Super + Ctrl + h` | Focus monitor to the left |
| `Super + Ctrl + l` | Focus monitor to the right |
| `Super + Ctrl + Shift + h` | Move active window to monitor on the left |
| `Super + Ctrl + Shift + l` | Move active window to monitor on the right |
| `Super + Ctrl + Shift + f` | Resize active window to 90% of the current monitor |
| `Super + Ctrl + Shift + r` | Reset focused Dwindle split ratio to center |
| `Super + Ctrl + Shift + c` | Center active floating window |
| `Super + Ctrl + Shift + m` | Middle monitor off profile: disable `DP-3`, move `DP-1` next to `DP-2` |
| `Super + Ctrl + Alt + m` | All monitors on profile: restore `DP-3`, move `DP-1` back right |
| `Super + Ctrl + Alt + Backspace` | Exit Hyprland only when no windows are open |

### Mouse

| Key | Action |
|-----|--------|
| `Super + left mouse drag` | Move window |
| `Super + right mouse drag` | Resize window |

### Utilities

| Key | Action |
|-----|--------|
| `Print` | Region screenshot with `grim`, `slurp`, and `swappy` |
| `Super + Shift + s` | Region screenshot with `grim`, `slurp`, and `swappy` |
| `Super + c` | Clipboard history with `cliphist`, `rofi`, and `wl-copy` |
| volume keys | Volume up/down/mute with `pamixer` |
| playback keys | Play/pause/next/previous with `playerctl` |
| brightness keys | Brightness up/down with `brightnessctl` |

## macOS / yabai + skhd

Config files:

- `yabai/.yabairc`
- `skhd/.skhdrc`
- `karabiner/.config/karabiner/karabiner.json`
- `scripts/yabai-*.sh`
- `scripts/open-*.sh`

### Applications

| Key | Action |
|-----|--------|
| `alt + return` | Open a new WezTerm window on the current Space and focus it |
| `alt + b` | Open a new Safari window on the current Space and focus it |
| `alt + y` | Open YouTube in Brave on the current Space and focus it |
| `alt + q` | Close active yabai window |

### Window Focus

| Key | Action |
|-----|--------|
| `alt + h` | Focus west |
| `alt + j` | Focus south |
| `alt + k` | Focus north |
| `alt + l` | Focus east |
| `alt + s` | Focus display west |
| `alt + g` | Focus display east |

### Spaces

| Key | Action |
|-----|--------|
| `alt + p` | Previous Space |
| `alt + n` | Next Space |
| `ctrl + 1..9` | Focus Space 1..9 |

### Layout

| Key | Action |
|-----|--------|
| `hyper + e` | Balance windows |
| `hyper + r` | Rotate layout |
| `hyper + y` | Mirror y-axis |
| `hyper + x` | Mirror x-axis |
| `hyper + f` | Native macOS fullscreen |
| `hyper + m` | yabai zoom fullscreen |
| `hyper + t` | Toggle floating centered window |

### Window Movement

| Key | Action |
|-----|--------|
| `hyper + h` | Swap west |
| `hyper + j` | Swap south |
| `hyper + k` | Swap north |
| `hyper + l` | Swap east |
| `ctrl + alt + h/j/k/l` | Warp west/south/north/east |
| `hyper + s` | Move focused window to display west and follow |
| `hyper + g` | Move focused window to display east and follow |
| `hyper + p` | Move focused window to previous Space without following |
| `hyper + n` | Move focused window to next Space without following |
| `hyper + 1..9` | Move focused window to Space 1..9 without following |
| `shift + hyper + p` | Move focused window to previous Space and follow |
| `shift + hyper + n` | Move focused window to next Space and follow |
| `shift + hyper + 1..9` | Move focused window to Space 1..9 and follow |

> Spaces are static (9 of them, created once in Mission Control). Dynamic
> create/destroy binds need yabai's scripting addition (SIP partially disabled)
> and are disabled in `.skhdrc`. See the README "Spaces" note.

### Resize

| Key | Action |
|-----|--------|
| `cmd + ctrl + h` | Resize west |
| `cmd + ctrl + j` | Resize south |
| `cmd + ctrl + k` | Resize north |
| `cmd + ctrl + l` | Resize east |

### Services

| Key | Action |
|-----|--------|
| `ctrl + alt + q` | Stop yabai |
| `ctrl + alt + s` | Start yabai |
| `ctrl + alt + r` | Restart yabai, skhd, and SketchyBar |
| `cmd + ctrl + s` | Reload SketchyBar |

Terminal fallback when hotkeys are dead: `restart-dots` or `restart-wm`.

## Karabiner

| Key | Action |
|-----|--------|
| tap `Caps Lock` | `Escape` |
| hold `Caps Lock` | `shift + ctrl + alt + cmd` Hyper |
| `Fn` | Remapped to left Control |
| left Control | Remapped to `Fn` |
