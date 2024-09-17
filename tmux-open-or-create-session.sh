#!/usr/bin/env bash

## A script to either open existing or create new tmux session for the given path.

session_path=$(realpath "$1")
session_name=$(basename "$1" | tr . _)

tmux_running=$(pgrep tmux)

if [[ -z "$TMUX" ]] && [[ -z "$tmux_running" ]]; then
	tmux new-session -s "$session_name" -c "$session_path"
	exit 0
fi

if ! tmux has-session -t="$session_name" 2>/dev/null; then
	tmux new-session -ds "$session_name" -c "$session_path"
fi

tmux switch-client -t "$session_name"
