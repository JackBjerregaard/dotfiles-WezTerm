#!/bin/bash

echo "🚀 Installing dotfiles..."

# Backup existing files
backup_dir=~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p $backup_dir

for file in .zshrc .tmux.conf .p10k.zsh .wezterm.lua; do
    if [ -f ~/$file ]; then
        echo "📦 Backing up existing $file"
        mv ~/$file $backup_dir/
    fi
done

# Create symlinks
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.wezterm.lua ~/.wezterm.lua

# Clone nvim config if it doesn't exist
if [ ! -d ~/.config/nvim ]; then
    echo "📦 Cloning nvim config..."
    git clone https://github.com/JackBjerregaard/nvim-config.git ~/.config/nvim
else
    echo "✅ Nvim config already exists"
fi

echo ""
echo "✅ Dotfiles installed!"
echo "🔄 Reload your shell: source ~/.zshrc"
echo "🎨 Configure p10k: p10k configure"
echo "📦 Install tmux plugins: Ctrl+A then Shift+I"
