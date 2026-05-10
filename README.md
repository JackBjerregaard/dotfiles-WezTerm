# My Dotfiles

Terminal configuration files managed with GNU Stow.

## Structure
```
dotfiles/
├── zsh/         # Zsh + Powerlevel10k config
├── tmux/        # Tmux configuration
├── wezterm/     # WezTerm terminal emulator
├── yabai/       # yabai tiling window manager
├── skhd/        # skhd hotkeys for yabai
└── sketchybar/  # SketchyBar status bar
```

## Installation

### Prerequisites

**macOS:**
```bash
brew install git zsh tmux eza zoxide bat neovim stow
brew install asmvik/formulae/yabai asmvik/formulae/skhd
brew tap FelixKratz/formulae
brew install sketchybar switchaudio-osx nowplaying-cli lua
brew install --cask wezterm
brew install --cask font-meslo-lg-nerd-font font-jetbrains-mono-nerd-font font-sketchybar-app-font
brew install zsh-autosuggestions zsh-syntax-highlighting
```

The SketchyBar config uses SbarLua:
```bash
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua
make install
```

Optional Apple fonts used by some SF Symbols can be installed with:
```bash
brew install --cask sf-symbols font-sf-mono font-sf-pro
```

Those Apple font packages may require an interactive sudo password prompt.

**Linux (WSL/Ubuntu):**
```bash
sudo apt update
sudo apt install git zsh tmux stow neovim
```

**All platforms:**
```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install zsh-vi-mode plugin
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode
```

### Setup
```bash
# Clone dotfiles
git clone git@github.com:JackBjerregaard/dotfiles-WezTerm.git ~/dotfiles

# Clone nvim config
git clone git@github.com:JackBjerregaard/neovim-config.git ~/.config/nvim

# Stow all configs
cd ~/dotfiles
stow zsh tmux wezterm yabai skhd sketchybar

# Reload shell
source ~/.zshrc

# Configure Powerlevel10k (first time only)
p10k configure

# Install tmux plugins (in tmux: Ctrl+A then Shift+I)
```

Start the macOS services:
```bash
yabai --start-service
skhd --start-service
brew services start sketchybar
```

## Usage
```bash
# Install a config
stow zsh

# Remove a config
stow -D zsh

# Restow (useful after making changes)
stow -R zsh
```

## Window Management

### Services
```bash
yabai --restart-service
skhd --restart-service
sketchybar --reload
```

### skhd Keybinds

Modifier names:
- `alt` = Option
- `cmd` = Command
- `ctrl` = Control
- `shift` = Shift
- Hyper-style bindings use `shift + ctrl + alt + cmd`

Launch:
- `alt + return`: open WezTerm

Focus windows:
- `alt + h/j/k/l`: focus west/south/north/east
- `alt + s/g`: focus display west/east

Focus spaces:
- `alt + p/n`: previous/next space
- `alt + 1..7`: focus space 1..7
- `ctrl + 1..9`: focus space 1..9

Layout:
- `shift + ctrl + alt + cmd + e`: balance windows
- `shift + ctrl + alt + cmd + r`: rotate layout
- `shift + ctrl + alt + cmd + y`: mirror y-axis
- `shift + ctrl + alt + cmd + x`: mirror x-axis
- `shift + ctrl + alt + cmd + m`: yabai zoom fullscreen
- `shift + alt + f`: native macOS fullscreen
- `shift + ctrl + alt + cmd + t`: toggle floating centered window

Move windows:
- `shift + ctrl + alt + cmd + h/j/k/l`: swap west/south/north/east
- `ctrl + alt + h/j/k/l`: warp west/south/north/east
- `shift + ctrl + alt + cmd + s/g`: move to display west/east
- `shift + ctrl + alt + cmd + p/n`: move to previous/next space
- `shift + ctrl + alt + cmd + 1..7`: move to space 1..7
- `shift + alt + 1..9`: move to space 1..9 and follow
- `shift + alt + p`: move to previous space and follow
- `shift + alt + n`: create a new space, move the focused window there, focus it, and reload SketchyBar

Resize windows:
- `shift + alt + h/j/k/l`: resize west/south/north/east

Service controls:
- `ctrl + alt + q`: stop yabai
- `ctrl + alt + s`: start yabai
- `ctrl + alt + r`: restart yabai and skhd, then reload SketchyBar
- `cmd + ctrl + s`: reload SketchyBar

### SketchyBar

The bar config lives at:
```bash
~/.config/sketchybar/sketchybarrc
```

It is managed from:
```bash
~/dotfiles/sketchybar/.config/sketchybar/
```

Included widgets:
- spaces 1..10 with app icons
- focused app name
- app menu/space toggle
- media artwork and playback popup
- Wi-Fi SSID and network details popup
- volume percentage, scroll control, and output device picker
- CPU graph
- battery percentage and time estimate popup
- date and time

## RISC-V Helpers
- `rv32-gcc`: wraps `riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O1 -nostartfiles -nostdlib` so `rv32-gcc file.c lib.c -o file.elf` works the same on macOS and Linux/WSL.
- `riscv-objdump`: disassembles with source (`-d -S`). Points to the Homebrew toolchain on macOS and the CompSys toolchain on Linux/WSL.
- `riscv-sim` (Linux/WSL only): runs `$HOME/CompSys-2025/tools/riscv-sim/sim-linux`.
- `riscv-run <elf> [args…]` (Linux/WSL only): convenience wrapper around `riscv-sim` that forwards extra arguments.
- `rars`: launches the correct RARS jar for each OS.

## Neovim Config

Neovim configuration is kept in a separate repo:
https://github.com/JackBjerregaard/neovim-config
