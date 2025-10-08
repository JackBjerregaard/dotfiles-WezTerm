# My Dotfiles

Terminal setup with WezTerm, Zsh, Tmux, and Powerlevel10k theme.

## 🎨 What's Included

- **Shell:** Zsh with Oh My Zsh
- **Theme:** Powerlevel10k
- **Terminal:** WezTerm with custom coolnight theme
- **Multiplexer:** Tmux with TPM
- **Tools:** eza, zoxide, bat, zsh-autosuggestions, zsh-syntax-highlighting

## 📦 Installation on Mac

### 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

### 2. Install required tools
brew install git zsh tmux eza zoxide bat
brew install --cask wezterm
brew install font-meslo-lg-nerd-font

### 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### 4. Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### 5. Install zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

### 6. Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### 7. Clone and install dotfiles
git clone https://github.com/JackBjerregaard/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh

### 8. Final steps
source ~/.zshrc
p10k configure
