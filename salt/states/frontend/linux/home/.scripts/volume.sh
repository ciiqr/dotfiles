#!/usr/bin/env bash

sink::get_default()
{
    pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}

sink::change_volume()
{
    readonly SINK="$1"
    readonly DIRECTION="$2"
    readonly PERCENT="$3"
    readonly CURRENT_PERCENT="$(sink::get_volume "$SINK")"

    # don't allow going over 100%
    if [[ "${CURRENT_PERCENT%\%}" -ge '100' && "$DIRECTION" == "+" ]]; then
        return
    fi

    pactl -- set-sink-volume "$SINK" "$DIRECTION$PERCENT"
}

sink::toggle_mute()
{
    readonly SINK="$1"
    pactl set-sink-mute "$SINK" toggle
}

sink::get_volume()
{
    readonly SINK="$1"
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'"$SINK"'>"}
            /^\s+volume: / && indefault {print $5; exit}'
}

sink::is_muted()
{
    readonly SINK="$1"
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'"$SINK"'>"}
            /^\s+muted: / && indefault {print $2; exit}'
}

main()
{
    case "$1" in
        change)
            sink::change_volume "$(sink::get_default)" "$2" "$3"
            ;;
        toggle-mute)
            sink::toggle_mute "$(sink::get_default)"
            ;;
        get)
            sink::get_volume "$(sink::get_default)"
            ;;
        is-muted)
            sink::is_muted "$(sink::get_default)"
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/volume.sh change + 10%'
            echo '  ~/.scripts/volume.sh change - 10%'
            echo '  ~/.scripts/volume.sh toggle-mute'
            ;;
    esac
}

main "$@"
