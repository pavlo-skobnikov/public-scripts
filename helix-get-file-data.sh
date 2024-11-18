#!/usr/bin/env bash

## Outputs `<FILENAME> <LINE_NUMBER>` to stdout.
## This script is to be by other scripts to add extra functionality to helix.

echo $(tmux capture-pane -p | rg -e "(?:NOR|INS|SEL)\s+[\x{2800}-\x{28FF}]*\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
