#!/usr/bin/env bash

# platform
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
    [[ "$OSTYPE" == linux* ]] && ! system::is_windows
}

# os
system::is_void_linux()
{
    grep -q '^ID="void"$' /etc/os-release 2>/dev/null
}

system::is_arch_linux()
{
    grep -q '^ID=arch$' /etc/os-release 2>/dev/null
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
        is-void-linux)
            system::is_void_linux
            ;;
        is-arch-linux)
            system::is_arch_linux
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/system.sh is-windows'
            echo '  ~/.scripts/system.sh is-osx'
            echo '  ~/.scripts/system.sh is-linux'
            echo '  ~/.scripts/system.sh is-void-linux'
            echo '  ~/.scripts/system.sh is-arch-linux'
            ;;
    esac
}

main "$@"
