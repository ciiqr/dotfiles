#!/usr/bin/env bash

calc()
{
    bc -l <<< "result = ($@); scale=0; result / 1"
}

clamp()
{
    readonly VALUE="$1"
    readonly MIN="$2"
    readonly MAX="$3"

    if [[ "$VALUE" -gt "$MAX" ]]; then
        readonly NEW="$MAX"
    elif [[ "$VALUE" -lt $MIN ]]; then
        readonly NEW="$MIN"
    else
        readonly NEW="$VALUE"
    fi

    echo "$NEW"
}

brightness::change_percent()
{
    readonly DIRECTION="$1"
    readonly PERCENT="$2"

    declare MAX=$(brightness::get_max)
    declare CURRENT=$(brightness::get)
    declare RAW_NEW="$(calc "$CURRENT $DIRECTION ($MAX * ($PERCENT / 100))")"
    declare NEW="$(clamp "$RAW_NEW" '0' "$MAX")"

    brightness::change "$NEW"
}

brightness::get_percent()
{
    declare MAX_BRIGHTNESS=$(brightness::get_max)
    declare CURRENT_BRIGHTNESS=$(brightness::get)
    declare PERCENT=$(calc "($CURRENT_BRIGHTNESS / $MAX_BRIGHTNESS) * 100")

    echo "${PERCENT}"
}

brightness::change()
{
    readonly VALUE="$1"

    # TODO: * may not really be a good idea...
    echo "$VALUE" | sudo tee /sys/class/backlight/*/brightness >/dev/null
}

brightness::get()
{
    # TODO: * may not really be a good idea...
    cat /sys/class/backlight/*/brightness
}

brightness::get_max()
{
    # TODO: * may not really be a good idea...
    cat /sys/class/backlight/*/max_brightness
}

main()
{
    case "$1" in
        change)
            # TODO: validate params
            brightness::change_percent "$2" "$3"
            ;;
        get)
            brightness::get_percent
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/brightness.sh change + 10%'
            echo '  ~/.scripts/brightness.sh change - 10%'
            echo '  ~/.scripts/brightness.sh get'
            ;;
    esac
}

main "$@"

# TODO: Could list all devices in /sys/class/backlight/, maybe device/type can be used to exclude the improper one
# TODO: Only do this is there is a backlight (and only setup keybindings if these exist...)
