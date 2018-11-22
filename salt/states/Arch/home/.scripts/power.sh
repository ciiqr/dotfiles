#!/usr/bin/env bash

power::suspend()
{
    systemctl suspend
}

power::hibernate()
{
    systemctl hibernate
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
        suspend)
            power::suspend
            ;;
        hibernate)
            power::hibernate
            ;;
        shutdown)
            power::shutdown
            ;;
        reboot)
            power::reboot
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/power.sh suspend'
            echo '  ~/.scripts/power.sh hibernate'
            echo '  ~/.scripts/power.sh shutdown'
            echo '  ~/.scripts/power.sh reboot'
            ;;
    esac
}

main "$@"
