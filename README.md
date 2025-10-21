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
brew install git zsh tmux eza zoxide bat neovim stow
brew install --cask wezterm
brew install font-meslo-lg-nerd-font
brew install zsh-autosuggestions zsh-syntax-highlighting
```

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

## Neovim Config

Neovim configuration is kept in a separate repo:
https://github.com/JackBjerregaard/neovim-config
