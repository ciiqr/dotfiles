#!/usr/bin/env bash

declare subcommand="$1"
declare title="$2"
declare message="$3"
# TODO: fix up with proper options
# TODO: maybe keep that common part in a base/frontend notification.sh & have some library files per platform
# TODO: may need to switch out osascript with a proper app with timeouts (or at least wait till dismissed) options
# declare opt="$4"
# declare time="$5"

if [[ "$#" == 0 ]]; then
    echo 'usage: '
    echo '  ~/.scripts/notification.sh send <title> <message> [-t time]'
    exit 1
fi

if [[ "$subcommand" == 'send' ]]; then
    osascript -e 'display notification "'"$message"'" with title "'"$title"'"'
else
    echo "invalid subcommand: ${subcommand}"
    exit 1
fi
