#!/usr/bin/env bash

temperature::get()
{
    # TODO: make this smarter
    sensors coretemp-isa-0000 2>/dev/null | sed -n 's/.*:\s*+\([0-9]*\).*/\1/p' | head -1
    sensors dell_smm-isa-0000 2>/dev/null | sed -n 's/.*:\s*+\([0-9]*\).*/\1/p' | head -1
}

main()
{
    case "$1" in
        get)
            temperature::get
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/temperature.sh get'
            ;;
    esac
}

main "$@"
