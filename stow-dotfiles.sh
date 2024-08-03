#!/usr/bin/env sh

## A script to (re-)stow my dotfile configurations.

# Add dotfiles to the directory stack.
pushd ~/dotfiles

# Iterate over all directories in the current directory.
for dir in ~/dotfiles/*/; do
    basename_dir=$(basename $dir)

    echo "Stowing $basename_dir"
    
    # Unstow the directory if it is already stowed.
    stow -D $basename_dir
    # Stow the directory.
    stow $basename_dir
done

# Clean up the directory stack.
popd