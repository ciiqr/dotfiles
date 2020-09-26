#!/usr/bin/env bash

main()
{
    declare program
    declare user="$USER"

    # TODO: support passing in a user so longer as it comes before the actual command (ie. first args must be -u USERNAME)

    # NOTES:
    # - sudo indicates running as root (currently only supports current user or root)
    # - first non-sudo part is assumed to be the program
    for part in "$@"; do
        # TODO: gksudo also
        if [[ "$part" == "sudo" ]]; then
            user=root
        else
            program="$part"
            break
        fi
    done

    # run if not already running
    # TODO: exec doesn't account for user, sudo (or gksudo it)
    is-running "$program" "$user" || exec "$@"
}

main "$@"
