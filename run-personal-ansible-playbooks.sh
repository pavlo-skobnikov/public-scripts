#!/usr/bin/env sh

## A script to choose and run my personal Ansible playbooks.
## The playbook can be run as a whole or tags from within (that are
## dynamically retrieved) can be chosen to run only parts of it.

# Add the directory with the playbooks to the stack.
pushd ~/ansible || exit

# Select a playbook.
selected_playbook=$(fd --type file --exact-depth 1 -e yml | fzf)

# Dynamically retrieve tags from the selected playbook.
all_playbook_tags_array=$(grep "tags" $selected_playbook | sed 's/.*tags: //g')

# Remove repeating entries from the array.
unique_playbook_tags_array=$(echo "${all_playbook_tags_array[@]}" | sort -u)

# Add an option to run all tasks from the playbook.
unique_playbook_tags_array+=("\nall-tasks")

# Select either a dynamically retrieved tag or the `all-tasks` option.
selected_option=$(echo "${unique_playbook_tags_array[@]}" | fzf)

# If the selected option is `all-tasks` then run the ansible playbook in full.
# Otherwise, the selected option is a tag and the ansible playbook should run
# only its tasks with the provided tag.
if [ "$selected_option" = "all-tasks" ]; then
    ansible-playbook "$selected_playbook"
else
    ansible-playbook "$selected_playbook" --tags "$selected_option"
fi

popd || exit
