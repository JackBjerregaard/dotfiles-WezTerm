#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[ OK ]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
die()     { echo -e "${RED}[ERR ]${NC} $*" >&2; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVIM_REPO="git@github.com:JackBjerregaard/neovim-config.git"

# ── OS Detection ──────────────────────────────────────────────────────────────

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif grep -qi "microsoft" /proc/version 2>/dev/null; then
    echo "wsl"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  else
    echo "unknown"
  fi
}

OS=$(detect_os)
info "Detected OS: $OS"

detect_linux_id() {
  if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    echo "${ID:-unknown}"
  else
    echo "unknown"
  fi
}

# ── Package managers ──────────────────────────────────────────────────────────

install_brew() {
  if command -v brew >/dev/null 2>&1; then
    success "Homebrew already installed"
    return
  fi
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for this session (Linux/WSL)
  if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

# ── Platform-specific setup ───────────────────────────────────────────────────

setup_macos() {
  info "Installing macOS packages..."
  install_brew
  brew install git zsh tmux eza zoxide bat neovim stow node jq
  brew install asmvik/formulae/yabai asmvik/formulae/skhd
  brew tap FelixKratz/formulae
  brew install sketchybar switchaudio-osx nowplaying-cli lua
  brew install --cask wezterm karabiner-elements
  brew install --cask font-meslo-lg-nerd-font font-jetbrains-mono-nerd-font font-sketchybar-app-font
  brew install zsh-autosuggestions zsh-syntax-highlighting

  info "Installing SbarLua..."
  if [[ ! -f "$HOME/.local/share/lua/5.4/sbar.so" ]]; then
    git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
    pushd /tmp/SbarLua >/dev/null
    make install
    popd >/dev/null
    rm -rf /tmp/SbarLua
  else
    success "SbarLua already installed"
  fi
}

set_macos_defaults() {
  info "Applying macOS defaults..."
  defaults write com.apple.dock AppleSpacesSwitchOnActivate -bool false
  killall Dock >/dev/null 2>&1 || true
}

setup_linux() {
  info "Installing Linux packages..."
  local linux_id
  linux_id="$(detect_linux_id)"

  case "$linux_id" in
    arch)
      sudo pacman -Syu --needed git zsh tmux stow curl wget base-devel
      ;;
    ubuntu | debian)
      sudo apt update -q
      sudo apt install -y git zsh tmux stow curl wget build-essential

      install_brew
      brew install neovim eza zoxide bat node jq
      ;;
    *)
      warn "Unsupported Linux distro '$linux_id' — install packages manually, then stow configs"
      ;;
  esac
}

# ── Common setup (all platforms) ─────────────────────────────────────────────

setup_omz() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    success "Oh My Zsh already installed"
    return
  fi
  info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_p10k() {
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "$dir" ]]; then
    success "Powerlevel10k already installed"
    return
  fi
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dir"
}

setup_tpm() {
  if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    success "TPM already installed"
    return
  fi
  info "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

setup_zsh_vi_mode() {
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
  if [[ -d "$dir" ]]; then
    success "zsh-vi-mode already installed"
    return
  fi
  info "Installing zsh-vi-mode..."
  git clone https://github.com/jeffreytse/zsh-vi-mode "$dir"
}

setup_nvim() {
  if [[ -d "$HOME/.config/nvim" ]]; then
    success "Neovim config already exists"
    return
  fi
  info "Cloning Neovim config..."
  git clone "$NVIM_REPO" "$HOME/.config/nvim" \
    || warn "Could not clone Neovim config — set up SSH keys and run: git clone $NVIM_REPO ~/.config/nvim"
}

stow_configs() {
  info "Stowing configs..."
  cd "$DOTFILES_DIR"
  stow -t "$HOME" zsh tmux
  if [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
    stow -t "$HOME" linux hypr waybar
  fi
  if [[ "$OS" == "macos" ]]; then
    stow -t "$HOME" wezterm yabai skhd sketchybar karabiner wallpapers
  fi
  success "Configs stowed"
}

install_tmux_plugins() {
  local installer="$HOME/.tmux/plugins/tpm/bin/install_plugins"
  if [[ ! -x "$installer" ]]; then
    warn "TPM installer not found — skipping tmux plugins"
    return
  fi
  info "Installing tmux plugins..."
  "$installer" || warn "Could not install tmux plugins — in tmux, press Ctrl+A then Shift+I"
}

set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$SHELL" == "$zsh_path" ]]; then
    success "zsh is already the default shell"
    return
  fi
  info "Setting zsh as default shell..."
  # Add zsh to /etc/shells if missing (common on Linux)
  if ! grep -qF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path"
}

start_macos_services() {
  info "Starting macOS services..."
  yabai --start-service  || true
  skhd --start-service   || true
  brew services start sketchybar || true
}

# ── Main ──────────────────────────────────────────────────────────────────────

main() {
  info "Dotfiles directory: $DOTFILES_DIR"

  case "$OS" in
    macos)          setup_macos ;;
    wsl | linux)    setup_linux ;;
    *)              warn "Unrecognised OS — skipping package install" ;;
  esac

  setup_omz
  setup_p10k
  setup_tpm
  setup_zsh_vi_mode
  setup_nvim
  stow_configs
  install_tmux_plugins

  if command -v npm >/dev/null 2>&1; then
    info "Installing npm global packages..."
    "$DOTFILES_DIR/scripts/install-npm-globals.sh"
  else
    warn "npm not found — skipping npm globals"
  fi

  set_default_shell

  if [[ "$OS" == "macos" ]]; then
    set_macos_defaults
    start_macos_services
  fi

  echo ""
  success "Done! Next steps:"
  echo "  1.  Restart your terminal, or run:  exec zsh"
  echo "  2.  Configure prompt (first time):  p10k configure"
  if [[ "$OS" == "macos" ]]; then
    echo "  3.  Optional Apple fonts (interactive sudo prompt):"
    echo "        brew install --cask sf-symbols font-sf-mono font-sf-pro"
  fi
}

main "$@"
