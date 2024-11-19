#!/bin/bash

## I have a convention where I put my project-related scripts into a project
## top-level directory `scripts`. This script allows to conveniently fuzzy
## search and execute scripts found in the `scripts` directory.

# Select a script.
selected_script=$(fd --type file --exact-depth 1 -e sh . ./scripts | fzf)

# Run the script.
"./$selected_script"
