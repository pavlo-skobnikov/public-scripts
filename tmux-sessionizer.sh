#!/usr/bin/env bash

## A script to either open existing or create new tmux session for the set of directories with
## fuzzy searching.

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    selected=$(find \
        ~/dotfiles \
        ~/dev/projects \
        ~/dev/projects/work \
        ~/dev/projects/personal \
        -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z "$selected" ]]; then
    exit 0
fi

~/tmux-open-or-create-session.sh $selected
