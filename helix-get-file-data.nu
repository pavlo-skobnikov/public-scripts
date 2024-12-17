#!/usr/bin/env nu

## This script returns nuon (Nushell Object Notation ->
## https://www.nushell.sh/commands/docs/to_nuon.html) containing the following
## columns:
##   - `fPath`: The absolute file path of the currently focused file in Helix.
##   - `lineAndCol`: The current line and column numbers of the active cursor
##                   in the above-mentioned file.

tmux capture-pane -p -S 0
  | lines
  | find -r "(NOR|INS|SEL) "
  | split column -r " +"
  | select column3 column6
  | rename fPath lineAndCol
  | update fPath { realpath $in }
  | to nuon
