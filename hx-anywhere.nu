#!/usr/bin/env nu

## This script is a simplified adaptation of the `vim-anywhere` project by
## Chris Knadler. REFERENCE: https://github.com/cknadler/vim-anywhere
##
## This script doesn't do anything fancy like automatically grabbing the
## currently edited text or pasting the resulting text back into the original
## application.
##
## It only quickly opens an Alacritty window with an empty Helix buffer. After
## saving and quitting, the buffer is copied into the system clipboard for
## further usage.

# Save the currenlty-focused application to later switch back to it.
let current_app = (osascript -e `tell application "System Events"`
  -e `copy (name of application processes whose frontmost is true) to stdout`
  -e `end tell`)

# This file will hold the result text edited by Helix.
let compose_file = "/tmp/hx-edit-anywhere.md"

# Make the compose file empty, optionally creating it if it doesn't exist.
'' | save --force $compose_file

# Edit the compose file with Helix.
alacritty -e /opt/homebrew/bin/nu -c $"hx ($compose_file)"

# Copy the contents of the compose file into the system clipboard.
open --raw $compose_file | pbcopy
