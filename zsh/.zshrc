# =============================================================================
# 1. INSTANT PROMPT (Must remain at the very top)
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# 2. ENVIRONMENT & PATH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8

# CompSys: Dotnet and Local Binaries
export PATH="$HOME/opt/bin:$HOME/.local/bin:$PATH"

# =============================================================================
# 3. OH-MY-ZSH CONFIGURATION
# =============================================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin Settings
# Set "jk" to exit Insert Mode immediately (zsh-vi-mode specific)
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# Load Plugins
# zsh-vi-mode is now correctly included here
plugins=(
  git
  zsh-vi-mode
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# 4. HOMEBREW & OS SPECIFIC SETUP
# =============================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
  BREW_PREFIX="/opt/homebrew"
  alias wezconfig="nvim ~/.wezterm.lua"
  export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
else
  # Linux (WSL)
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  alias wezconfig="nvim /mnt/c/Users/giaco/.wezterm.lua"
  export DOTNET_ROOT="/home/linuxbrew/.linuxbrew/opt/dotnet/libexec"
fi

# Add .NET to PATH
export PATH="$DOTNET_ROOT:$HOME/.dotnet/tools:$PATH"

# =============================================================================
# 5. ADDITIONAL ZSH ENHANCEMENTS (Loaded after OMZ)
# =============================================================================
# Source Homebrew plugins (Syntax highlighting & Autosuggestions)
if [[ -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Keybindings for history search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^F' autosuggest-accept

# History Settings
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Initialize Zoxide (Better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# =============================================================================
# 6. ALIASES & TOOLS
# =============================================================================
alias ls="eza --icons=always"
alias sync-wez="cp ~/.wezterm.lua ~/dotfiles/wezterm/.wezterm.lua && echo '✓ WezTerm config synced to dotfiles'"

# --- RISC-V Toolchain (CompSys) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  RISCV_TOOLCHAIN_ROOT="$HOME/Documents/CompSys/CompSys-2025/tools/riscv"
  RISCV_SIM_BIN_DIR="$HOME/Documents/CompSys/CompSys-2025/tools/riscv-sim"
else
  RISCV_TOOLCHAIN_ROOT="$HOME/CompSys-2025/tools/riscv"
  RISCV_SIM_BIN_DIR="$HOME/CompSys-2025/tools/riscv-sim"
fi

# Add RISC-V Binaries to Path
if [[ -d "$RISCV_TOOLCHAIN_ROOT/bin" ]]; then
  export PATH="$RISCV_TOOLCHAIN_ROOT/bin:$PATH"
fi

# GCC Alias
if command -v riscv64-unknown-elf-gcc >/dev/null 2>&1; then
  alias rv32-gcc="riscv64-unknown-elf-gcc -march=rv32im -mabi=ilp32 -O1 -nostartfiles -nostdlib"
fi

# RARS Alias
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias rars='java -jar ~/Documents/CompSys/rars1_6.jar'
else
  alias rars='java -jar ~/CompSys-2025/rars1_5.jar'
fi

# RISC-V Simulator Setup
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    RISCV_SIM_BIN="$RISCV_SIM_BIN_DIR/sim-mac"
  else
    RISCV_SIM_BIN="$RISCV_SIM_BIN_DIR/sim-mac-x86"
  fi
  alias riscv-objdump="riscv64-unknown-elf-objdump -d -S"
else
  RISCV_SIM_BIN="$RISCV_SIM_BIN_DIR/sim-linux"
  alias riscv-objdump="riscv32-unknown-elf-objdump -d -S"
fi

alias riscv-sim="$RISCV_SIM_BIN"

# Helper function to run ELF files
riscv-run() {
  local elf="$1"
  shift || true
  "$RISCV_SIM_BIN" "$elf" -- "$@"
}

# =============================================================================
# 7. FINAL INIT
# =============================================================================
# P10k Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
