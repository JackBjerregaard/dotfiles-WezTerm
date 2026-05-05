# My Dotfiles

Terminal configuration files managed with GNU Stow.

## Structure
```
dotfiles/
├── zsh/         # Zsh + Powerlevel10k config
├── tmux/        # Tmux configuration
└── wezterm/     # WezTerm terminal emulator
```

## Installation

### Prerequisites

**macOS:**
```bash
brew install git zsh tmux eza zoxide bat neovim stow node
brew install --cask wezterm
brew install font-meslo-lg-nerd-font
brew install zsh-autosuggestions zsh-syntax-highlighting
```

**Linux (WSL/Ubuntu):**
```bash
sudo apt update
sudo apt install git zsh tmux stow neovim nodejs npm
```

**npm globals (all platforms):**
```bash
# Add packages to npm-global-packages.txt, then install them with:
./scripts/install-npm-globals.sh
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
stow zsh tmux wezterm

# Install npm global packages listed in npm-global-packages.txt
./scripts/install-npm-globals.sh

# Reload shell
source ~/.zshrc

# Configure Powerlevel10k (first time only)
p10k configure

# Install tmux plugins (in tmux: Ctrl+A then Shift+I)
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

## RISC-V Helpers
- `rv32-gcc`: wraps `riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O1 -nostartfiles -nostdlib` so `rv32-gcc file.c lib.c -o file.elf` works the same on macOS and Linux/WSL.
- `riscv-objdump`: disassembles with source (`-d -S`). Points to the Homebrew toolchain on macOS and the CompSys toolchain on Linux/WSL.
- `riscv-sim` (Linux/WSL only): runs `$HOME/CompSys-2025/tools/riscv-sim/sim-linux`.
- `riscv-run <elf> [args…]` (Linux/WSL only): convenience wrapper around `riscv-sim` that forwards extra arguments.
- `rars`: launches the correct RARS jar for each OS.

## Neovim Config

Neovim configuration is kept in a separate repo:
https://github.com/JackBjerregaard/neovim-config
