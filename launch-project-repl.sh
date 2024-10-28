#!/bin/bash

## A script to start a REPL session in the current project. Resolves the
## current project type (i.e. language and/or build system) and chooses the
## appropriate command to start the REPL.

repl_command=""

if [ -f ./deps.edn ]; then
	# For Clojure deps project.
	repl_command="clj"
elif [ -f ./build.sbt ]; then
	# Types of SBT REPL to start up.
	sbt_repl_options=("console" "console-quick")

	# Use fzf to select the REPL option.
	selected_sbt_repl=$(printf '%s\n' "${sbt_repl_options[@]}" | fzf --height 40% --reverse --border)

	# Compose the REPL command.
	repl_command="sbt $selected_sbt_repl"
fi

# If no known project type was discovered, exit the script.
if [ -z "$repl_command" ]; then
	echo "Couldn't resolve the current project!"
	exit 1
fi

# Start a project-specific REPL in the right pane.
$repl_command
