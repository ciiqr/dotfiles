#!/usr/bin/env bash

programs::_find_paths_to_command() {
    # NOTE: can't use which -a because it prints '{command} not found' to stdout
    type -a "$1" 2>/dev/null | sed -n 's:'"$1"' is \(/.*\):\1:p'
}

programs::_file_identity() {
    if [[ "$OSTYPE" == darwin* ]]; then
        stat -Lf "%d:%i" "$1" 2>/dev/null
    else
        stat -Lc "%d:%i" "$1" 2>/dev/null
    fi
}

programs::find_first_suitable() {
    # find first command that doesn't point to the script that called us
    declare selected_command=''
    declare current_script_id
    current_script_id="$(programs::_file_identity "${BASH_SOURCE[-1]}")"

    for command in "$@"; do
        for path in $(programs::_find_paths_to_command "$command"); do
            if [[ "$current_script_id" != "$(programs::_file_identity "$path")" ]]; then
                selected_command="$path"
                break 2
            fi
        done
    done

    if [[ -z "$selected_command" ]]; then
        echo 'No suitable command found:' "${commands[@]}" >&2
        return 1
    fi

    # return selected command
    echo "$selected_command"
}

programs::run_first_suitable() {
    # pull all commands until --
    declare -a commands=()
    while [[ "$#" -gt 0 && "$1" != '--' ]]; do
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
    declare selected_command
    selected_command="$(programs::find_first_suitable "${commands[@]}")"
    if [[ -z "$selected_command" ]]; then
        return 1
    fi

    # run selected command
    exec "$selected_command" "${args[@]}"
}
