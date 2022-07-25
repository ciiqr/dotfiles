#!/usr/bin/env bash

set -e

declare i=0
declare count="$(tput colors)"
while (( i < count )); do
    # print all colours
    tput setaf "$i"
    echo -n "FOREGROUND: $i "
    tput setab "$i"
    echo -n "BACKGROUND: $i"
    tput sgr0
    echo

    # print similar colours offset 3
    # declare offset=3
    # if (( i % 6 == offset )); then
    #     tput setaf "$i"
    #     echo -n "FOREGROUND: $i "
    #     tput setab "$i"
    #     echo -n "BACKGROUND: $i"
    #     tput sgr0
    #     echo
    # fi

    (( i++ )) || true
done
