# My Dotfiles

Terminal and system configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Config | Description |
|--------|-------------|
| `zsh/` | Zsh + Oh My Zsh + Powerlevel10k |
| `tmux/` | Tmux + TPM |
| `wezterm/` | WezTerm terminal emulator |
| `sketchybar/` | macOS status bar |
| `yabai/` | macOS tiling window manager (macOS only) |
| `skhd/` | macOS hotkey daemon (macOS only) |
| `karabiner/` | Karabiner-Elements keyboard remaps (macOS only) |
| `claude/` | Claude AI settings & skills |

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
brew install git zsh tmux eza zoxide bat neovim stow node
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
brew install neovim eza zoxide bat node
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
stow zsh tmux wezterm yabai skhd sketchybar karabiner

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

---

## Stow Usage

```bash
stow zsh        # Link a config
stow -D zsh     # Unlink a config
stow -R zsh     # Relink (useful after making changes)
```

---

## Window Management (macOS)

### skhd Keybinds

Modifier names: `alt` = Option, `cmd` = Command, `ctrl` = Control, `shift` = Shift.
`hyper` means `shift + ctrl + alt + cmd`.

Karabiner maps `Caps Lock` to `Escape` when tapped and Hyper when held, so `Caps Lock + h` triggers `hyper + h`. It also swaps the global `Fn` key and left `Control`.

**Launch:**
- `alt + return`: open WezTerm

**Focus windows:**
- `alt + h/j/k/l`: focus west/south/north/east
- `alt + s/g`: focus display west/east

**Focus spaces:**
- `alt + p/n`: previous/next space
- `alt + 1..7`: focus space 1..7
- `ctrl + 1..9`: focus space 1..9

**Layout:**
- `hyper + e`: balance windows
- `hyper + r`: rotate layout
- `hyper + y`: mirror y-axis
- `hyper + x`: mirror x-axis
- `hyper + m`: yabai zoom fullscreen
- `shift + alt + f`: native macOS fullscreen
- `hyper + t`: toggle floating centered window

**Move windows:**
- `hyper + h/j/k/l`: swap west/south/north/east
- `ctrl + alt + h/j/k/l`: warp west/south/north/east
- `hyper + s/g`: move to display west/east
- `hyper + p/n`: move to previous/next space
- `hyper + 1..7`: move to space 1..7
- `shift + alt + 1..9`: create missing spaces up to 1..9, move the focused window there, follow, and re-focus the window
- `shift + alt + p`: move to previous space and follow
- `shift + alt + n`: create new space, move focused window there, reload SketchyBar
- `ctrl + alt + n`: create new empty space, focus it, reload SketchyBar
- `shift + alt + d`: destroy current space, reload SketchyBar
- `ctrl + alt + d`: destroy all spaces except the current space, reload SketchyBar

**Resize windows:**
- `shift + alt + h/j/k/l`: resize west/south/north/east

**Service controls:**
- `ctrl + alt + q`: stop yabai
- `ctrl + alt + s`: start yabai
- `ctrl + alt + r`: restart yabai and skhd, reload SketchyBar
- `cmd + ctrl + s`: reload SketchyBar

### SketchyBar

Config lives at `~/.config/sketchybar/sketchybarrc` (managed from `~/dotfiles/sketchybar/.config/sketchybar/`).

Included widgets: spaces 1–10 with app icons, focused app name, app menu/space toggle, media artwork and playback popup, Wi-Fi SSID and details popup, volume percentage/scroll control/output picker, CPU graph, battery percentage and time estimate, date and time.

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
