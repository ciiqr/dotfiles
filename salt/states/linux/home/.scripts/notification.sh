#!/usr/bin/env bash

declare subcommand="$1"
declare title="$2"
declare message="$3"
# TODO: fix up with proper options
# TODO: maybe keep that common part in a base/frontend notification.sh & have some library files per platform
declare opt="$4"
declare time="$5"

if [[ "$#" == 0 ]]; then
    echo 'usage: '
    echo '  ~/.scripts/notification.sh send <title> <message> [-t time]'
    exit 1
fi

if [[ "$subcommand" == 'send' ]]; then
    declare -a args=()
    if [[ -n "$title" ]]; then
        args+=("$title")
    fi
    if [[ "$opt" == '-t' ]]; then
        args+=('-t' "$time")
    fi
    args+=("$message")

    notify-send "${args[@]}"
else
    echo "invalid subcommand: ${subcommand}"
    exit 1
fi
