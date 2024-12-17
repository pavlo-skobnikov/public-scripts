#!/usr/bin/env nu

## This script provides functionality to create and/or switch to `tmux`
## sessions quickly. 3 entry points exist for the script with the following
## differing functionalities:
##   - tmux-sessionizer.nu [ABSOLUTE_PATH]: Providing an absolute path as the
##       argument to the script, the script either creates a session with
##       the name being the most-nested directory name and the provided path
##       being the session root or simply switches to an existing session with
##       the matching session name.
##   - tmux-sessionizer.nu common-paths: Fuzzy select a directory path from a
##       predefined set of directories and create/switch to a corresponding
##       tmux session following the logic described above.
##   - tmux-sessionizer.nu active-sessions: Fuzzy select an active tmux session
##       and switch to it.

def main [session_path: string] {
    print $session_path
    let session_name = get_session_name_from_path $session_path

    if not (is_an_active_session_present $session_name) {
        tmux new-session -ds $"($session_name)" -c $"($session_path)"
    }

    tmux switch-client -t $"($session_name)"
}

def "main common-paths" [] {
    print "common"
    let session_path = select_common_path_for_session
    let session_name = get_session_name_from_path $session_path

    if not (is_an_active_session_present $session_name) {
        tmux new-session -ds $"($session_name)" -c $"($session_path)"
    }

    tmux switch-client -t $"($session_name)"
}

def "main active-sessions" [] {
    let session_name = select_active_session_name

    tmux switch-client -t $"($session_name)"
}

# For a given path, returns the last part (i.e. the most nested directory).
def get_session_name_from_path [path: string] {
    $path
        | str trim --right --char "/"
        | split row "/"
        | last
        | str replace "." "_"
}

# Prompts to select a directory from within a set of directories via `fzf` to
# be later on used for session creation/switching.
def select_common_path_for_session [] {
    (fd .
        ~
        ~/dotfiles
        ~/dev/projects
        ~/dev/projects/work
        ~/dev/projects/personal
        --min-depth 1 --max-depth 1 --type directory)
        | fzf
        | realpath $in
}


# Prompts to select an active tmux session via `fzf` to switch to.
def select_active_session_name [] {
    tmux list-sessions
        | lines
        | split column " "
        | get column1
        | str trim --right --char ":"
        | str join "\n"
        | fzf
}

# Checks if an active session exists for the provided session name.
def is_an_active_session_present [session_name: string] {
    tmux has-session -t $session_name
        | complete
        | $in.exit_code == 0
}
