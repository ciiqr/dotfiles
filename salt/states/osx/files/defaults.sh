#!/usr/bin/env bash

set -e

stateful_exit()
{
    declare code="$1"
    declare changed="$2"
    declare comment="$3"

    if [[ "$#" != 3 ]]; then
        echo 'usage: stateful_exit <code> <changed> <comment>'
        exit 1
    fi

    # write state line
    echo
    echo "changed='${changed}' comment='${comment}'"
    exit "$code"
}

# previous value
declare previous_value="$(defaults read "$@")"

# write
defaults write "$@"

# new value
declare new_value="$(defaults read "$@")"

# check if value changed
if [[ "$previous_value" != "$new_value" ]]; then
    stateful_exit 0 'yes' "$1 $2: was changed to ${*:3}"
fi

# value unchanged
stateful_exit 0 'no' ''
