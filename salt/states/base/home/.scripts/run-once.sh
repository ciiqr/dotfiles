#!/usr/bin/env bash

# TODO: move to .local/bin? or remove version I have there...

main()
{
    declare program
    declare user="$USER"

    # NOTES:
    # - sudo indicates running as root (currently only supports current user or root)
    # - first non-sudo part is assumed to be the program
    for part in $@; do
        if [[ "$part" == "sudo" ]]; then
            user=root
        else
            program="$part"
            break
        fi
    done

    # run if not already running
    is-running "$program" "$user" || "$@"
}

main "$@"
