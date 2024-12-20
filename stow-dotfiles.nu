#!/usr/bin/env nu

use std/dirs

# Add dotfiles to the directory stack.
dirs add ~/dotfiles

ls | filter { $in.type == dir } | get name | each { 
  print $"Removing stow links for ($in)..."
  stow -D $in

  print $"Stowing ($in)..."
  stow $in
}

# Clean up the directory stack.
dirs drop
