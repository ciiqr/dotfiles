#!/usr/bin/env bash

# platform
system::is_macos()
{
    [[ "$OSTYPE" == darwin* ]]
}

system::is_linux()
{
    [[ "$OSTYPE" == linux* ]]
}

system::get_platform()
{
    if system::is_macos; then
        echo 'macos'
    elif system::is_linux; then
        echo 'linux'
    fi
}

# hostname
system::get_hostname()
{
    if [[ -n "$HOST" ]]; then
        echo "$HOST"
    elif [[ -n "$HOSTNAME" ]]; then
        echo "$HOSTNAME"
    else
        hostname
    fi
}

system::main()
{
    case "$1" in
        is-macos)
            system::is_macos
            ;;
        is-linux)
            system::is_linux
            ;;
        get-platform)
            system::get_platform
            ;;
        get-hostname)
            system::get_hostname
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/system.sh is-macos'
            echo '  ~/.scripts/system.sh is-linux'
            echo '  ~/.scripts/system.sh is-arch-linux'
            echo '  ~/.scripts/system.sh get-platform'
            echo '  ~/.scripts/system.sh get-hostname'
            ;;
    esac
}

system::main "$@"
