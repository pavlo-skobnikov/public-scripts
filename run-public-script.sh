#!/bin/bash

## I forget what scripts I have 😓 This script allows easily picking which
## other public script to run.
pushd ~/public-scripts || exit

# Select a script.
selected_script=$(fd --type file --exact-depth 1 -e sh | fzf)

# Run the script.
"./$selected_script"

popd || exit
