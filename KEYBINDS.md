# Keybind Cheatsheet

This file documents the cross-platform window-management model used by these dotfiles.

## Modifier Model

| Role | macOS / AeroSpace | Linux / Hyprland |
|------|-----------------------|------------------|
| Main window-manager modifier | `alt` / Option | `Super` |
| Move/modify window modifier | `hyper` = `ctrl + alt + cmd` | `Super + Shift` |
| Numbered workspace focus | `ctrl + 1..9` | `Super + 1..9` |
| Extra monitor layer | Mostly unused on laptop | `Super + Ctrl` |

Notes:

- macOS `alt` is treated like Linux `Super` for app launching, focus, and workspace navigation.
- macOS `hyper` is treated like Linux `Super + Shift` for moving windows and workspaces.
- macOS numbered workspaces stay on `ctrl + 1..9` because `alt + number` can collide with normal symbol entry, especially on non-US keyboard layouts.
- AeroSpace workspaces and Hyprland workspaces are the same workflow concept: virtual desktops. Note that AeroSpace workspaces are *not* macOS Spaces — see `aerospace/WORKSPACES.md`.
- AeroSpace monitors and Hyprland monitors are the same hardware concept: physical screens.

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

## macOS / AeroSpace

Config files:

- `aerospace/.config/aerospace/aerospace.toml` — window manager **and** hotkeys
- `karabiner/.config/karabiner/karabiner.json`
- `scripts/restart-macos-ui.sh`

There is no separate hotkey daemon. AeroSpace handles its own key binding, so
the whole macOS window-management setup is one TOML file. See
[`MIGRATION-yabai-to-aerospace.md`](MIGRATION-yabai-to-aerospace.md) for what
this replaced and why.

> **Why every `hyper` bind is listed once but written twice in the config.**
> Karabiner maps held Caps Lock to `shift + ctrl + alt + cmd` (four modifiers),
> while physically pressing the hyper cluster gives `ctrl + alt + cmd` (three).
> Each action is bound under both so either input works. The one deliberate
> exception is moving a window to a workspace, where the `shift` variant also
> follows the window.

### Applications

| Key | Action |
|-----|--------|
| `alt + return` | Open a new WezTerm window on the current workspace |
| `alt + b` | Open a new Safari window on the current workspace |
| `alt + y` | Open YouTube in Brave on the current workspace |
| `alt + q` | Close active window |

New windows land on the focused workspace automatically, so these are plain
`open` calls. The old versions went through ~190 lines of helper script that
polled for the new window and dragged it onto the current Space.

### Window Focus

| Key | Action |
|-----|--------|
| `alt + h` | Focus left |
| `alt + j` | Focus down |
| `alt + k` | Focus up |
| `alt + l` | Focus right |
| `alt + s` | Focus monitor left (wraps) |
| `alt + g` | Focus monitor right (wraps) |

### Workspaces

| Key | Action |
|-----|--------|
| `alt + p` | Previous workspace (wraps) |
| `alt + n` | Next workspace (wraps) |
| `ctrl + 1..9` | Focus workspace 1..9 |

Nine workspaces always exist (`persistent-workspaces` in `aerospace.toml`) and
are created by AeroSpace itself. SketchyBar shows `1..5` by default and reveals
`6..9` when they are focused or contain windows, including intermediate hidden
workspaces when a higher one is used. Nothing to set up in Mission Control, and
no dead keys when a workspace is empty.

### Layout

| Key | Action |
|-----|--------|
| `hyper + e` | Balance window sizes |
| `hyper + r` | Toggle split orientation (horizontal ⇄ vertical) |
| `hyper + y` | Flatten the workspace tree |
| `hyper + x` | Toggle accordion ⇄ tiles |
| `hyper + f` | macOS native fullscreen — for video / single-app focus |
| `hyper + m` | AeroSpace fullscreen (fills the workspace, no new Space) |
| `hyper + t` | Toggle floating / tiling |

`hyper + y` and `hyper + x` were mirror y-axis / x-axis under yabai. AeroSpace
has no mirror command, so the keys were repurposed to two things it does have
rather than left dead.

`hyper + f` creates a real macOS Space, but a transient one macOS removes when
you exit fullscreen. Exit it rather than leaving a window stuck — leftover
Spaces strand windows (see [`aerospace/WORKSPACES.md`](aerospace/WORKSPACES.md)).
`hyper + m` never touches Spaces.

### Window Movement

| Key | Action |
|-----|--------|
| `hyper + h/j/k/l` | Swap window left/down/up/right (focus follows) |
| `ctrl + alt + h/j/k/l` | Move window left/down/up/right within the layout tree |
| `hyper + s` | Move window to monitor left and follow |
| `hyper + g` | Move window to monitor right and follow |
| `hyper + p` | Move window to previous workspace, stay put |
| `hyper + n` | Move window to next workspace, stay put |
| `hyper + 1..9` | Move window to workspace 1..9, stay put |
| `shift + hyper + p` | Move window to previous workspace and follow |
| `shift + hyper + n` | Move window to next workspace and follow |
| `shift + hyper + 1..9` | Move window to workspace 1..9 and follow |

Because held Caps Lock produces the `shift` variant, Caps Lock + a number moves
**and follows**. Press the `ctrl + alt + cmd` cluster physically to move without
following.

### Resize

| Key | Action |
|-----|--------|
| `cmd + ctrl + h` | Narrower |
| `cmd + ctrl + l` | Wider |
| `cmd + ctrl + k` | Shorter |
| `cmd + ctrl + j` | Taller |

Simplified from yabai, which resized a named edge by 20px and needed a fallback
for when no neighbour existed in that direction.

### Service Mode

`alt + shift + ;` enters a one-shot mode; every key below returns to normal.

| Key | Action |
|-----|--------|
| `esc` | Reload config |
| `r` | Flatten workspace tree |
| `f` | Toggle floating / tiling |
| `backspace` | Close all windows but the current one |
| `alt + shift + h/j/k/l` | Join window with neighbour left/down/up/right |

### Services

| Key | Action |
|-----|--------|
| `ctrl + alt + r` | Reload AeroSpace config and SketchyBar |
| `cmd + ctrl + s` | Reload SketchyBar |

Terminal fallback: `restart-dots` or `restart-wm`.

The config also auto-reloads whenever `aerospace.toml` is saved.

AeroSpace is a normal application that starts at login via its own
`start-at-login` setting — not a launchd service. This is deliberate. yabai and
skhd were launchd agents, and `--stop-service` ran `launchctl disable`, writing
to a persistent override database that survived reboots; one stray keypress
could leave the window manager dead indefinitely with no visible error. That
whole failure mode no longer exists, which is why there is no start/stop bind.

## Karabiner

| Key | Action |
|-----|--------|
| tap `Caps Lock` | `Escape` |
| hold `Caps Lock` | `shift + ctrl + alt + cmd` Hyper |
| `Fn` | Remapped to left Control |
| left Control | Remapped to `Fn` |
