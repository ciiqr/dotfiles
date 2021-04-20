#!/usr/bin/env bash

power::lock()
{
    slimlock
}

power::suspend()
{
    systemctl suspend
}

power::hibernate()
{
    systemctl hibernate
}

power::logout()
{
    awesome-client 'awesome.quit()'
}

power::shutdown()
{
    systemctl poweroff
}

power::reboot()
{
    systemctl reboot
}

main()
{
    case "$1" in
        lock)
            power::lock
            ;;
        suspend)
            power::suspend
            ;;
        hibernate)
            power::hibernate
            ;;
        logout)
            power::logout
            ;;
        shutdown)
            power::shutdown
            ;;
        reboot)
            power::reboot
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/power.sh lock'
            echo '  ~/.scripts/power.sh suspend'
            echo '  ~/.scripts/power.sh hibernate'
            echo '  ~/.scripts/power.sh logout'
            echo '  ~/.scripts/power.sh shutdown'
            echo '  ~/.scripts/power.sh reboot'
            ;;
    esac
}

main "$@"
