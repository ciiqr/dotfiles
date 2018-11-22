#!/usr/bin/env bash

power::suspend()
{
    sudo zzz
}

power::hibernate()
{
    sudo ZZZ
}

power::shutdown()
{
    sudo poweroff
}

power::reboot()
{
    sudo reboot
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
