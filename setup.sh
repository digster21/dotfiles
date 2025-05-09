#!/usr/bin/env bash

set -e

USER_HOME="$HOME"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "$DOTFILES_DIR"

# List dotfile
dotfiles=(".bashrc" ".vimrc" ".gitconfig" ".tmux.conf")

for file in "${dotfiles[@]}"; do
    target="$USER_HOME/$file"
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
