#!/usr/bin/env bash

set -e

pad_to_centre() {
    declare width="$1"
    declare char="$2"
    declare text="$3"

    declare padding
    padding="$(printf '%0.1s' "${char}"{1..500})"

    printf '%*.*s %s %*.*s\n' 0 "$(((width - 2 - ${#text}) / 2))" "$padding" "$text" 0 "$(((width - 1 - ${#text}) / 2))" "$padding"
}

# colour count
declare count
count="$(tput colors)"

# loop offsets
declare offset=0
declare maxOffset=36
while ((offset < maxOffset)); do
    # loop index
    declare i="$offset"
    while ((i < count)); do
        # print color
        tput setaf "$i"
        tput setab "$i"
        echo -n "|$(pad_to_centre '10' ' ' "$i")|"
        tput sgr0

        i=$((i + maxOffset))
    done
    echo

    offset=$((offset + 1))
done
