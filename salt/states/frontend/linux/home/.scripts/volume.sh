#!/usr/bin/env bash

getDefaultSink()
{
    pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}

main()
{
    case "$1" in
        change)
            pactl -- set-sink-volume "$(getDefaultSink)" "$2$3"
            ;;
        toggle-mute)
            pactl set-sink-mute "$(getDefaultSink)" toggle
            ;;
        get)
            pacmd list-sinks |
                awk '/^\s+name: /{indefault = $2 == "<'$(getDefaultSink)'>"}
                    /^\s+volume: / && indefault {print $5; exit}'
            ;;
        is-muted)
            pacmd list-sinks |
                awk '/^\s+name: /{indefault = $2 == "<'$(getDefaultSink)'>"}
                    /^\s+muted: / && indefault {print $2; exit}'
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
