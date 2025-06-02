#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Working in: $DOTFILES_DIR"

###############################################################################
# Link config files
###############################################################################

DOT_BASHRC=".bashrc"
DOT_VIMRC=".vimrc"
DOT_GITCONF=".gitconfig"
DOT_TMUXCONF=".tmux.conf"

# List dotfile
dotfiles=("$DOT_BASHRC" "$DOT_VIMRC" "$DOT_GITCONF" "$DOT_TMUXCONF")

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

###############################################################################
# Install font
###############################################################################

FONT="JetBrainsMono"
FONT_DIR="$HOME/.local/share/fonts/$FONT"
FONT_ARCHIVE="$FONT.tar.xz"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_ARCHIVE"

# Check if font already exists
if [ ! -d "$FONT_DIR" ]; then
    if ! command -v curl >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y curl
        echo "curl installed"
    fi
    
    # Install font
    curl -OL "$FONT_URL"

    # Extract font
    mkdir -p "$FONT_DIR"
    tar -xf "$FONT_ARCHIVE" -C "$FONT_DIR"

    # Reload font cache
    fc-cache -fv

    # Delete font archive
    rm "$FONT_ARCHIVE"

    echo "$FONT installed at $FONT_DIR"
fi

###############################################################################
# Install TMUX + related deps
###############################################################################

# Install tmux
if ! command -v tmux >/dev/null 2>& 1; then 
    sudo apt update && sudo apt install -y tmux
    echo "tmux installed"
fi

# Install tmux package manager
TMUX_TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_TPM_URL="git@github.com:tmux-plugins/tpm.git"

if [ ! -d "$TMUX_TPM_DIR" ]; then
    mkdir -p "$TMUX_TPM_DIR"
    git clone "$TMUX_TPM_URL" "$TMUX_TPM_DIR"
        
    echo "TMUX TPM installed"
fi

# Start tmux with config file
if [ -f "$HOME/$DOT_TMUXCONF" ]; then 
    echo "Set TMUX source file with 'tmux source-file $HOME/$DOT_TMUXCONF'"
fi

