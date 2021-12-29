#!/usr/bin/env bash

programs::_find_paths_to_command()
{
    # NOTE: can't use which -a because it prints '{command} not found' to stdout
    type -a "$1" 2>/dev/null | sed -n 's:'"$1"' is \(/.*\):\1:p'
}

programs::_stat_link()
{
    if type gstat 2>/dev/null; then
        gstat -Lc "%d:%i" "$1"
    else
        stat -Lc "%d:%i" "$1"
    fi
}

programs::run_first_suitable()
{
    # pull all commands until --
    declare -a commands=()
    while [[ "$#" -gt 0 && "$1" != "--" ]]; do
        commands+=("$1")
        shift # next
    done

    # skip --
    shift

    # parse all args after --
    declare -a args=()
    while [[ "$#" -gt 0 ]]; do
        args+=("$1")
        shift # next
    done

    # find first command that doesn't point to the script that called us
    declare selected_command=''
    declare stat_current_script="$(programs::_stat_link "${BASH_SOURCE[-1]}")"

    for command in "${commands[@]}"; do
        for path in $(programs::_find_paths_to_command "$command"); do
            if [[ "$stat_current_script" != "`programs::_stat_link "$path"`" ]]; then
                selected_command="$path"
                break 2
            fi
        done
    done

    if [[ -z "$selected_command" ]]; then
        echo 'No suitable command found:' "${commands[@]}"
        exit 1
    fi

    # run selected command
    exec "$selected_command" "${args[@]}"
}
