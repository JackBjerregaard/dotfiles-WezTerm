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
| `scripts/` | Bootstrap installer, npm global installer, yabai/skhd helper scripts |
| `wallpapers/` | Wallpaper collections stowed into `~/Pictures/Wallpapers` |
| `npm-global-packages.txt` | Global npm packages installed by `scripts/install-npm-globals.sh` |

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

**1. Install system packages:**
```bash
sudo apt update
sudo apt install -y git zsh tmux stow curl wget build-essential
```

**2. Install Homebrew for Linux** (recommended — provides newer tool versions):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

**3. Install tools via brew:**
```bash
brew install neovim eza zoxide bat node jq
```

**4. Continue to [Common Setup](#common-setup)**

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

# Linux / WSL — zsh + tmux only (skip macOS-only targets):
stow zsh tmux
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
