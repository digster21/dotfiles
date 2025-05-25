#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "$DOTFILES_DIR"

# List dotfile
dotfiles=(".bashrc" ".vimrc" ".gitconfig" ".tmux.conf")

for file in "${dotfiles[@]}"; do
    target="$HOME/$file"
    source="$DOTFILES_DIR/$file"


    if [ ! -e "$source" ]; then 
	echo "Warning: $source does not exist in directory. Skipping."
	continue
    fi

    if [ -L "$target" ]; then 
        echo "Symlink already exists: $target -> $(readlink $target)"
        continue
    elif [ -e "$target" ]; then
        backup="$target.backup.$(date +%s)"
        echo "Backing up existing file: $target -> $backup"
        mv "$target" "$backup"
    fi

    ln -s "$source" "$target"
    echo "Linked: $target -> $source"
done

FONT="JetBrainsMono"
FONTS_DIR="$HOME/.local/share/fonts"
FONT_DIR="$FONTS_DIR/$FONT"
FONT_ARCHIVE="$FONT.tar.xz"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_ARCHIVE"

# Check if font already exists
if [ ! -d "$FONT_DIR" ]; then
    if ! command -v curl >/dev/null 2>&1; then
        echo "curl not found. Installing..."
        sudo apt update && sudo apt install -y curl
    fi

    curl -OL "$FONT_URL"

    mkdir -p "$FONT_DIR"
    tar -xf "$FONT_ARCHIVE" -C "$FONT_DIR"

    # Reload font cache
    fc-cache -fv

    echo "$FONT Nerd Font installed successfully."
else
    echo "$FONT already installed at $FONT_DIR"
fi

