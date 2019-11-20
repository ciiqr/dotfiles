#!/usr/bin/env bash

system::is_windows()
{
    grep -q 'Microsoft' '/proc/version' 2>/dev/null
}

system::is_osx()
{
    [[ "$OSTYPE" == darwin* ]]
}

system::is_linux()
{
    [[ "$OSTYPE" == linux* ]]
}

main()
{
    case "$1" in
        is-windows)
            system::is_windows
            ;;
        is-osx)
            system::is_osx
            ;;
        is-linux)
            system::is_linux
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/system.sh is-windows'
            echo '  ~/.scripts/system.sh is-osx'
            echo '  ~/.scripts/system.sh is-linux'
            ;;
    esac
}

main "$@"
