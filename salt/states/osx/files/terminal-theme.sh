#!/usr/bin/env bash

set -e

usage()
{
    echo "usage: terminal-theme.sh <theme_name> <theme_file>"
    echo "   ie. terminal-theme.sh mine mine.terminal"
}

get_default_theme()
{
    echo 'tell application "Terminal" to return name of current settings of first window' | osascript
}

set_default_theme()
{
    osascript <<EOF
    tell application "Terminal"
        local allOpenedWindows
        local initialOpenedWindows
        local windowID
        set themeName to "${1}"
        set themeFile to "${2}"

        (* Store the IDs of all the open terminal windows. *)
        set initialOpenedWindows to id of every window

        (* Open the custom theme so that it gets added to the list of available terminal themes. This will temporarily open additional windows. *)
        do shell script "open '" & themeFile & "'"

        (* Wait a little bit to ensure that the custom theme is added. *)
        delay 10

        (* Set the custom theme as the default terminal theme. *)
        set default settings to settings set themeName

        (* Get the IDs of all the currently opened terminal windows. *)
        set allOpenedWindows to id of every window

        repeat with windowID in allOpenedWindows
            if initialOpenedWindows does not contain windowID then
                (* Close the additional windows that were opened in order to add the custom theme to the list of terminal themes. *)
                close (every window whose id is windowID)
            else
                (* Change the theme for the initial opened terminal windows to remove the need to close them in order for the custom theme to be applied. *)
                set current settings of tabs of (every window whose id is windowID) to settings set themeName
            end if
        end repeat
    end tell
EOF
}

declare changed='no'
declare comment=''
declare exit_code=0

declare theme_name="$1"
declare theme_file="$2"

if [[ -z "$theme_name" || -z "$theme_file" ]]; then
    usage

    # update state
    comment="missing required parameters"
    exit_code=1
else
    declare current_theme="$(get_default_theme)"
    if [[ "$theme_name" != "$current_theme" ]]; then
        # change theme
        set_default_theme "$theme_name" "$theme_file"

        # update state
        changed='yes'
        comment="default theme was set to ${theme_name}"
    else
        comment="default theme was already ${theme_name}"
    fi
fi

# writing the state line
echo
echo "changed='${changed}' comment='${comment}'"
exit "$exit_code"
