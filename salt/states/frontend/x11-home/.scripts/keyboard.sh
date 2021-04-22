#!/usr/bin/env bash

keyboard::toggle_caps_lock()
{
    # Toggle
    xdotool key Caps_Lock

    # if -v param is supplied
    if [[ "$1" = "-v" ]]; then
        # If Caps Lock in on
        if xset -q | grep "Caps Lock: *on" 1>/dev/null; then
            # Going to Switch it off
            echo "On"
        else
            # Going to Switch it on
            echo "Off"
        fi
    fi
}

main()
{
    case "$1" in
        toggle-caps-lock)
            keyboard::toggle_caps_lock "${@:2}"
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/keyboard.sh toggle-caps-lock [-v]'
            ;;
    esac
}

main "$@"
