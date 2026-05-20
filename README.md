# My Dotfiles

Terminal and system configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Config | Description |
|--------|-------------|
| `zsh/` | Zsh, Oh My Zsh, Powerlevel10k, zsh-vi-mode, shell aliases, PATH setup, RISC-V helpers |
| `tmux/` | Tmux prefix/keybinds, TPM, navigation/session plugins, Tokyo Night theme |
| `wezterm/` | WezTerm theme, fonts, opacity, WSL default domain, close/scrollback keybinds |
| `sketchybar/` | macOS status bar, widgets, plugins, helper binaries, shared style variables |
| `yabai/` | macOS tiling window manager, signals, rules, spacing, opacity/focus behavior |
| `skhd/` | macOS hotkey daemon for app launching, focus, spaces, layout, moving, resizing, services |
| `karabiner/` | Karabiner-Elements keyboard remaps for Caps Lock Hyper and Fn/Control swap |
| `linux/` | Linux XDG defaults such as browser/application associations |
| `hypr/` | Linux Hyprland compositor config, window-management keybinds, monitor profiles, helper scripts |
| `waybar/` | Linux Waybar status bar config and styling |
| `scripts/` | Bootstrap installer, npm global installer, yabai/skhd helper scripts |
| `wallpapers/` | Wallpaper collections stowed into `~/Pictures/Wallpapers` |
| `packages/` | Optional Arch package reference lists for recreating a similar desktop |
| `npm-global-packages.txt` | Global npm packages installed by `scripts/install-npm-globals.sh` |
| `KEYBINDS.md` | Cross-platform keybind cheatsheet for macOS/yabai and Linux/Hyprland |

---

## Quick Start

Clone the repo and run the install script — it auto-detects your OS:

```bash
git clone https://github.com/JackBjerregaard/dotfiles-WezTerm.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

Or follow the manual steps below for your platform.

---

## Manual Setup by Platform

### macOS

**1. Install Homebrew:**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Install packages:**
```bash
brew install git zsh tmux eza zoxide bat neovim stow node jq
brew install asmvik/formulae/yabai asmvik/formulae/skhd
brew tap FelixKratz/formulae
brew install sketchybar switchaudio-osx nowplaying-cli lua
brew install --cask wezterm karabiner-elements
brew install --cask font-meslo-lg-nerd-font font-jetbrains-mono-nerd-font font-sketchybar-app-font
brew install zsh-autosuggestions zsh-syntax-highlighting
```

Optional Apple fonts (requires an interactive sudo prompt):
```bash
brew install --cask sf-symbols font-sf-mono font-sf-pro
```

**3. Install SbarLua** (required for SketchyBar Lua config):
```bash
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install
```

**4. Continue to [Common Setup](#common-setup)**

---

### Linux (Native)

**Arch Linux:**
```bash
sudo pacman -Syu --needed git zsh tmux stow curl wget base-devel
```

**Debian / Ubuntu:**
```bash
sudo apt update
sudo apt install -y git zsh tmux stow curl wget build-essential
```

**Install Homebrew for Linux on Debian / Ubuntu** (recommended — provides newer tool versions):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

**Install tools via brew on Debian / Ubuntu:**
```bash
brew install neovim eza zoxide bat node jq
```

Continue to [Common Setup](#common-setup).

> Window management tools and keyboard remaps (yabai, skhd, sketchybar, karabiner) are macOS-only — skip those stow targets.

---

### WSL2 (Windows Subsystem for Linux) — Recommended for Windows

**1. Enable WSL2** (run in PowerShell as Administrator, then restart):
```powershell
wsl --install
```

**2. Install Ubuntu** from the Microsoft Store, launch it, and follow the [Linux guide](#linux-native) above.

**WezTerm on Windows:** WezTerm runs natively on Windows and reads `~/.wezterm.lua` from your WSL2 home. After stowing in WSL2, symlink or copy the config to Windows:
```bash
# From inside WSL2 — links into the Windows user profile
ln -sf ~/dotfiles/wezterm/.wezterm.lua /mnt/c/Users/<YourWindowsUsername>/.wezterm.lua
```

> Window management tools (yabai, skhd, sketchybar) are macOS-only.

---

### Windows (Native — Limited)

GNU Stow is not available on native Windows, so most configs in this repo require WSL2.
The only config that works natively on Windows is WezTerm:

```powershell
# Copy WezTerm config manually
Copy-Item .\wezterm\.wezterm.lua $env:USERPROFILE\.wezterm.lua
```

For everything else, use WSL2 (see above).

---

## Common Setup

Run these steps after the platform-specific prerequisites above.

**1. Install Oh My Zsh:**
```bash
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**2. Install Powerlevel10k theme:**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

**3. Install Tmux Plugin Manager (TPM):**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

**4. Install zsh-vi-mode plugin:**
```bash
git clone https://github.com/jeffreytse/zsh-vi-mode \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
```

**5. Clone Neovim config:**
```bash
git clone git@github.com:JackBjerregaard/neovim-config.git ~/.config/nvim
```

**6. Stow configs:**
```bash
cd ~/dotfiles

# macOS — all configs:
stow zsh tmux wezterm yabai skhd sketchybar karabiner wallpapers

# Linux / WSL — shell, terminal, and Linux desktop configs:
stow zsh tmux linux hypr waybar
```

**7. Install npm global packages:**
```bash
./scripts/install-npm-globals.sh
```
Add packages to `npm-global-packages.txt` to include them in future installs.

**8. Set zsh as default shell:**
```bash
chsh -s $(which zsh)
```

**9. Reload and configure:**
```bash
exec zsh
p10k configure      # First time only
```

**10. Install tmux plugins:**
Start tmux, then press `Ctrl+A` then `Shift+I`.

---

## macOS Services

Start window management and status bar after stowing:
```bash
yabai --start-service
skhd --start-service
brew services start sketchybar
```

Restart services:
```bash
yabai --restart-service
skhd --restart-service
sketchybar --reload
```

The install script also applies this macOS default:

```bash
defaults write com.apple.dock AppleSpacesSwitchOnActivate -bool false
killall Dock
```

That keeps macOS from switching Spaces automatically when an app is activated.

---

## Stow Usage

```bash
stow zsh        # Link a config
stow -D zsh     # Unlink a config
stow -R zsh     # Relink (useful after making changes)
```

---

## Keybind Cheatsheet

See [`KEYBINDS.md`](KEYBINDS.md) for the consolidated macOS/yabai and Linux/Hyprland shortcut reference.

The cross-platform model is:

- macOS `alt` maps to Linux `Super` for app launching, window focus, and workspace navigation.
- macOS `hyper` maps to Linux `Super + Shift` for moving windows and workspaces.
- macOS numbered Spaces stay on `ctrl + 1..9` to avoid `alt + number` text-entry conflicts.
- macOS Spaces are the same workflow concept as Hyprland workspaces.
- macOS/yabai displays are the same hardware concept as Hyprland monitors.

---

## Window Management (Linux / Hyprland)

The Linux desktop config is managed from `hypr/.config/hypr/hyprland.conf` and stowed to `~/.config/hypr/hyprland.conf`.

Hyprland terminology:

- Workspaces are virtual desktops, equivalent to yabai/macOS Spaces.
- Monitors are physical screens, equivalent to yabai displays.
- The Linux setup uses `Super` as the main window-manager modifier.
- Window movement uses `Super + Shift`.
- Monitor movement uses `Super + Ctrl` so it does not collide with tile movement.
- Monitor movement is incremental: previous/next active monitor, so it still works when one display is off.
- Monitor geometry is configured left-to-right as `DP-2` at `0x0`, `DP-3` at `1080x240`, and `DP-1` at `3640x240`. `DP-2` is rotated with `transform, 1`, and the centered offsets keep the bar/visual layout aligned.

### Hyprland Keybinds

**Launch:**
- `super + return`: open WezTerm
- `super + d`: app launcher through Rofi
- `super + b`: open Chrome
- `super + y`: open YouTube in Brave

**Window state:**
- `super + q`: close active window
- `super + shift + q`: safely ask all applications to close
- `super + f`: fullscreen active window
- `super + v`: toggle floating
- `super + m`: exit Hyprland only when no windows are open
- `super + shift + escape`: exit Hyprland
- `super + shift + c`: dismiss all notifications

**Focus windows:**
- `super + h/j/k/l`: focus left/down/up/right

**Move windows inside the layout:**
- `super + shift + h/k/l`: move active window left/up/right

**Layout:**
- `super + shift + j`: toggle the focused Dwindle split between side-by-side and top-and-bottom
- `super + shift + r`: swap the two halves of the focused Dwindle split, mirroring the macOS `hyper + r` layout role

**Focus workspaces:**
- `super + 1..9`: focus workspace 1..9
- `super + p/n`: previous/next workspace

**Move windows to workspaces:**
- `super + shift + 1..9`: move active window to workspace 1..9
- `super + shift + p/n`: move active window to previous/next workspace

**Monitors:**
- `super + ctrl + h/l`: focus previous/next monitor
- `super + ctrl + shift + h/l`: move active window to previous/next monitor
- `super + ctrl + shift + f`: resize active window to 90% of the current monitor
- `super + ctrl + shift + c`: center active floating window
- `super + ctrl + shift + m`: middle monitor off profile; disable `DP-3` and move `DP-1` next to `DP-2`
- `super + ctrl + alt + m`: all monitors on profile; restore `DP-3` and move `DP-1` back to the right

**Mouse:**
- `super + left mouse drag`: move window
- `super + right mouse drag`: resize window

**Utilities:**
- `print`: region screenshot with `grim`, `slurp`, and `swappy`
- `super + shift + s`: region screenshot with `grim`, `slurp`, and `swappy`
- `super + c`: clipboard history through `cliphist`, `rofi`, and `wl-copy`

**Media keys:**
- Volume keys use `pamixer`
- Playback keys use `playerctl`
- Brightness keys use `brightnessctl`

### Hyprland Notes

- `super + q` intentionally means close, matching the preferred Linux workflow.
- `super + shift + q` uses `~/.config/hypr/scripts/close-all-clients.sh` to send normal close requests to all Hyprland clients.
- `super + m` is guarded by `~/.config/hypr/scripts/exit-if-empty.sh`, so it only exits when no Hyprland clients are open.
- Screenshot is on `super + shift + s`, leaving monitor movement on the vim-direction layer.
- `super + shift + j` is intentionally a Linux Dwindle split toggle now, so it no longer mirrors macOS `hyper + j` swap south.
- Monitor bindings use Hyprland's directional monitor targets, `mon:l` and `mon:r`, to move left/right through active monitors.
- Floating windows keep their size when moved between monitors. If a moved floating window does not fit, use `super + ctrl + shift + f` and then `super + ctrl + shift + c`.
- Physically turning off the middle monitor may leave it active in Hyprland. Use the middle-off monitor profile so mouse and window movement cross directly between the remaining monitors.
- Primeagen/Omarchy-inspired additions that were adopted: move-window-to-workspace bindings, mouse move/resize, and `super + shift + s` screenshot.

---

## Window Management (macOS)

The macOS desktop setup is split across:

- `yabai/.yabairc`: tiling behavior, signals, padding/gaps, opacity, mouse behavior, app rules
- `skhd/.skhdrc`: keyboard shortcuts that drive yabai, app launching, and service reloads
- `karabiner/.config/karabiner/karabiner.json`: low-level keyboard remaps used by the skhd Hyper chords
- `scripts/yabai-*.sh` and `scripts/open-*.sh`: helper commands used by the skhd shortcuts

Several helpers use `jq` to query yabai JSON output.

### skhd Keybinds

Modifier names: `alt` = Option, `cmd` = Command, `ctrl` = Control, `shift` = Shift.
`hyper` means `ctrl + alt + cmd` for physical key chords.
Caps Lock emits `shift + ctrl + alt + cmd`, and the main Hyper window actions accept that chord too.
`shift + hyper` means `shift + ctrl + alt + cmd`.

Karabiner maps `Caps Lock` to `Escape` when tapped and Hyper when held, so `Caps Lock + h` triggers `hyper + h`. It also swaps the global `Fn` key and left `Control`.

**Launch:**
- `alt + return`: open a new WezTerm window on the current space and focus it
- `alt + b`: open a new Safari window on the current space and focus it
- `alt + y`: open YouTube in Brave on the current space and focus it
- `alt + q`: close the active yabai window, mirroring Linux `super + q`

**Focus windows:**
- `alt + h/j/k/l`: focus west/south/north/east
- `alt + s/g`: focus display west/east

**Focus spaces:**
- `alt + p/n`: previous/next space, then focus a window there
- `ctrl + 1..9`: focus space 1..9, then focus a window there

**Layout:**
- `hyper + e`: balance windows
- `hyper + r`: rotate layout
- `hyper + y`: mirror y-axis
- `hyper + x`: mirror x-axis
- `hyper + m`: yabai zoom fullscreen
- `hyper + f`: native macOS fullscreen
- `hyper + t`: toggle floating centered window

**Move windows:**
- `hyper + h/j/k/l`: swap west/south/north/east
- `ctrl + alt + h/j/k/l`: warp west/south/north/east
- `hyper + s/g`: move focused window to display west/east and follow it
- `hyper + 1..9`: move focused window to space 1..9, follow it, and re-focus it
- `shift + hyper + 1..9`: create missing spaces up to 1..9, move the focused window there, follow, and re-focus the window
- `hyper + p/n`: move focused window to previous/next space, follow it, and re-focus it
- `shift + hyper + p`: move focused window to previous space and follow
- `shift + hyper + n`: create new space, move focused window there, reload SketchyBar
- `ctrl + alt + n`: create new empty space, focus it, reload SketchyBar
- `hyper + d`: destroy current space, reload SketchyBar
- `ctrl + alt + d`: destroy all empty spaces, reload SketchyBar

**Resize windows:**
- `cmd + ctrl + h/j/k/l`: resize west/south/north/east

**Service controls:**
- `ctrl + alt + q`: stop yabai
- `ctrl + alt + s`: start yabai
- `ctrl + alt + r`: restart yabai and skhd, reload SketchyBar
- `cmd + ctrl + s`: reload SketchyBar

### skhd Helper Scripts

- `scripts/open-app-current-space.sh <app-name> [app-path]`: opens a new app window, moves it back to the current yabai space if needed, then focuses it. Used by `alt + return` for WezTerm.
- `scripts/open-safari-current-space.sh`: creates a new Safari document/window, keeps it on the current yabai space, then focuses it. Used by `alt + b`.
- `scripts/open-url-current-space.sh <app-name> <app-path> <url>`: opens a URL in a new app window, moves it back to the current yabai space if needed, then focuses it. Used by `alt + y` for YouTube in Brave.
- `scripts/yabai-focus-current-space-window.sh [window-id]`: focuses the preferred window id, or the best visible window on the current space. Used after space/display changes and window moves.
- `scripts/yabai-move-window-to-display.sh <west|east|north|south|prev|next>`: moves the focused window to a display, follows it, then re-focuses the window.
- `scripts/yabai-move-window-to-relative-space.sh <prev|next>`: moves the focused window to the previous/next space, follows it, then re-focuses the window.
- `scripts/yabai-move-window-to-space.sh <space-index>`: creates missing spaces up to the target index, moves the focused window there, follows it, re-focuses it, and reloads SketchyBar if spaces were created.
- `scripts/yabai-destroy-empty-spaces.sh`: destroys every space with no visible non-Finder user windows, reloads SketchyBar, then focuses a window on the current space. This avoids Finder's desktop/background entry making an empty space look occupied.

### yabai Behavior

- Layout: BSP tiling with `second_child` placement, focused insertion point, automatic split type, 50/50 split ratio, and manual balancing.
- Spacing: 10px top padding, 8px bottom/left/right padding, and 8px gaps.
- Focus: mouse follows focus, focus does not follow mouse, and focus is repaired after window destruction, minimization, app termination, space changes, and display changes.
- Mouse: hold `ctrl` to move/resize windows; mouse drop swaps windows.
- Visuals: window shadows off, active windows at full opacity, inactive windows at 90% opacity, quick animations, and skipped focus animation.
- SketchyBar integration: triggers window focus updates when windows focus or titles change.
- Scripting addition: attempts `sudo -n yabai --load-sa` on startup and after Dock restarts. Configure sudoers/SIP separately if needed.
- Floating rules: System Settings, Calculator, Activity Monitor, Karabiner-Elements, 1Password, Preview, QuickTime Player, Disk Utility, and Archive Utility are unmanaged/floating.

### Karabiner

- Caps Lock: tap for Escape, hold for `shift + ctrl + alt + cmd` Hyper.
- Fn and left Control are swapped globally.
- The virtual keyboard type is ANSI.

### SketchyBar

Config lives at `~/.config/sketchybar/sketchybarrc` (managed from `~/dotfiles/sketchybar/.config/sketchybar/`).

Active widgets: spaces with app icons, focused app name, focused window title, DND, weather, volume, battery, calendar, and clock.

The bar uses shared colors and dimensions from `variables.sh`, app icons from `icon_map.sh`/`helpers/app_icons.lua`, item definitions from `items/`, and runtime scripts from `plugins/`. Helper binaries live under `helpers/event_providers/` and `helpers/menus/`.

The active item load order is:

- Left: spaces, front app, window title
- Right: clock, calendar, battery, volume, weather, DND

`sketchybarrc` enables hotload, runs an initial update, and starts `sketchybar-toggle`.

---

## Terminal Environment

### Zsh

- Loads Powerlevel10k instant prompt first.
- Uses Oh My Zsh with `git` and `zsh-vi-mode`.
- Sets `jk` as the zsh-vi-mode insert-mode escape chord.
- Loads Homebrew shellenv on macOS and Linux/WSL.
- Adds local bin paths, npm globals, .NET tools, Postgres.app tools on macOS, and Linuxbrew PostgreSQL clients when present.
- Loads Homebrew zsh autosuggestions and syntax highlighting when installed.
- Binds Up/Down and `Ctrl+P`/`Ctrl+N` to history search, and `Ctrl+F` to accept autosuggestions.
- Stores history in `~/.zhistory`, shares history, expires duplicates first, ignores duplicates, and verifies history expansion.
- Aliases `ls` to `eza --icons=always`, `cd` to `z` when zoxide is available, and includes a `sync-wez` helper to copy the live WezTerm config back to this repo.
- Configures NVM, OpenJDK on macOS, Bun on Linux/WSL, and a Linux/WSL `claude-mem` helper.

### Tmux

- Prefix is `Ctrl+A`; `Ctrl+B` is unbound.
- Windows and panes start at index 1.
- Splits: `prefix |` horizontal and `prefix -` vertical.
- Reload: `prefix r`.
- Pane resize: `prefix h/j/k/l` by 2 cells, `prefix Option+h/j/k/l` by 10 cells.
- Zoom pane: `prefix m`.
- Attach with current pane path: `prefix Option+c`.
- Mouse support is enabled.
- Copy mode uses vi keys: `v` starts selection and `y` copies.
- Escape time is reduced for fast Neovim mode switching.
- Plugins: TPM, vim-tmux-navigator, tmux-resurrect, tmux-continuum, and tmux-tokyo-night.
- Resurrect captures pane contents; continuum automatic restore is off; `prefix Ctrl+R` restores manually.

### WezTerm

- Uses a custom dark blue/green palette with MesloLGS Nerd Font Mono.
- Hides the tab bar, keeps resize-only window decorations, and uses 95% opacity.
- macOS uses font size 16 and background blur 10; other platforms use font size 12.
- Windows defaults to the `WSL:Ubuntu` domain.
- `Ctrl+Shift+K`: clear scrollback and viewport.
- `Cmd+W` and `Ctrl+Shift+W`: close the current pane without confirmation.

---

## Scripts

- `scripts/install.sh`: detects macOS, Linux, or WSL; installs packages; installs Oh My Zsh, Powerlevel10k, TPM, zsh-vi-mode, and the external Neovim config; stows configs; installs npm globals; sets zsh as the default shell; and starts macOS services.
- `packages/arch-pacman.txt`: optional native Arch package reference list.
- `packages/arch-aur.txt`: optional AUR package reference list.
- `scripts/install-npm-globals.sh`: reads `npm-global-packages.txt`, sets npm's global prefix to `~/.npm-global` unless `NPM_CONFIG_PREFIX` is set, and installs the listed packages globally.

Global npm packages currently listed:

- `@openai/codex`
- `tree-sitter-cli`

---

## RISC-V Helpers

- `rv32-gcc`: wraps `riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O1 -nostartfiles -nostdlib`
- `riscv-objdump`: disassembles with source (`-d -S`); points to the Homebrew toolchain on macOS and the CompSys toolchain on Linux/WSL
- `riscv-sim` (Linux/WSL only): runs the CompSys simulator binary
- `riscv-run <elf> [args…]` (Linux/WSL only): convenience wrapper around `riscv-sim`
- `rars`: launches the correct RARS jar for each OS

---

## Neovim Config

Kept in a separate repo: https://github.com/JackBjerregaard/neovim-config
