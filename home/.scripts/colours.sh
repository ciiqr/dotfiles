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

print_colour() {
    declare colour="$1"

    tput setaf "$colour"
    tput setab "$colour"
    echo -n "|$(pad_to_centre '10' ' ' "$colour")|"
    tput sgr0
}

print_set_1() {
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
            print_colour "$i"

            i=$((i + maxOffset))
        done
        echo

        offset=$((offset + 1))
    done
}

print_set_2() {
    declare total_offset=16

    # colour count
    declare count
    count="$(tput colors)"

    # loop offsets
    declare offset=0
    declare max_offset=36
    while ((offset < max_offset)); do
        # loop index
        declare i="$offset"
        i=$((total_offset + offset))
        while ((i < count)); do
            # print color
            print_colour "$i"

            i=$((i + max_offset))
        done
        echo

        offset=$((offset + 1))
    done
}

print_set_3() {
    declare total_offset=16

    # colour count
    declare count
    count="$(tput colors)"

    # loop offsets
    declare i="$total_offset"
    while ((i < count)); do
        declare j=0
        while ((j < 6)); do
            # print color
            print_colour "$((i + j))"

            j=$((j + 1))
        done
        echo

        i=$((i + j))
    done
}

print_set_4() {
    declare total_offset=16

    # colour count
    declare count
    count="$(tput colors)"

    # loop offsets
    declare i="$total_offset"
    while ((i <= 46)); do
        declare j="$i"
        while ((j < count)); do
            declare k="$j"
            declare ki=0
            while ((ki < 6)); do
                # print color
                print_colour "$k"

                k=$((k + 1))
                ki=$((ki + 1))
            done
            echo

            j=$((j + 36))
        done

        i=$((i + 6))
    done
}

declare set_index="${1:-1}"

"print_set_${set_index}"
