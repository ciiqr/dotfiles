#!/usr/bin/env bash

# NOTE: repo created with: restic init
# NOTE: for things that I intend to backup but have little need for locally, will either need to keep locally anyways, or have a separate host for storing those things (so they aren't attached to a host that's going to prune it's old stuff)

set -eo pipefail

backup::backup()
{
    # setup failure trigger
    failure()
    {
        # notify failure
        # TODO: this is dumb and only works because we're not using additional params in the osx send_notification script
        send_notification 'Backup' 'Failed!' -t 0
    }
    trap failure ERR

    # get host
    declare host="${HOST:-$HOSTNAME}"
    if [[ -z "$host" ]]; then
        echo 'Could not determine hostname'
        exit 1
    fi

    # notify start
    send_notification 'Backup' 'Started'

    # check repo
    backup::_step 'checking repo'
    restic check -q

    # prepare dynamic info
    backup::_step 'prepare dynamic info'
    backup::_prepare_dynamic_info

    # prepare paths to backup
    backup::_step 'prepare backup paths'
    declare -a paths=()
    backup::_prepare_backup_paths

    # actually backup data
    backup::_step 'backing up data'
    sudo -E restic backup "${paths[@]}"

    # prune
    backup::_step 'pruning old snapshots'
    restic forget --host "$host" --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 12

    # re-checking
    backup::_step 're-checking repo'
    restic check -q

    # notify finish
    send_notification 'Backup' 'Finished'
}

backup::mount()
{
    # TODO: this is only for platform supporting fuse
    # TODO: likely want a different dir for osx
    declare backups_directory='/mnt/backups'

    # ensure backups directory exists
    if [[ ! -d "$backups_directory" ]]; then
        sudo mkdir -p "$backups_directory"
    fi

    # mount
    backup::restic mount --allow-other "$@" "$backups_directory"
}

backup::restic()
{
    sudo -E restic "$@"
}

backup::_step()
{
    echo '==>' "$@"
}

backup::_is_windows()
{
    grep -q 'Microsoft' '/proc/version'
}

backup::_is_osx()
{
    [[ "$OSTYPE" == darwin* ]]
}

backup::_is_linux()
{
    [[ "$OSTYPE" == linux* ]]
}

backup::_append_existent_paths()
{
    declare potential_path
    for potential_path in "$@"; do
        if [[ -e "$potential_path" ]]; then
            paths+=("$potential_path")
        fi
    done
}

backup::_prepare_dynamic_info()
{
    :
    # TODO: for each different os
    # TODO: different for each...
    # - : package list
    # - : explicit package list

    # TODO: on windows, should /info paths live at /info or /mnt/c/info
}

backup::_prepare_backup_paths()
{
    # per-platform
    if backup::_is_linux; then
        paths+=(/etc)
    elif backup::_is_osx; then
        : # TODO:
    elif backup::_is_windows; then
        backup::_append_existent_paths '/mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/'
    fi

    # TODO: per-os

    # base
    backup::_append_existent_paths ~/{.histfile,.bash_history}

    # TODO: ensure dedup works properly between hosts
    # All synced files
    if backup::_is_windows; then
        # TODO: decide what the paths will actually be on windows
        # backup::_append_existent_paths /mnt/c/Users/william/{Documents,Projects,Inbox,Screenshots,.wallpapers}
        backup::_append_existent_paths /mnt/c/Users/william/Dropbox
    else
        backup::_append_existent_paths ~/{Dropbox,Documents,Projects,Inbox,Screenshots,.wallpapers}
    fi

    # Info
    if backup::_is_windows; then
        # TODO: decide what the paths will actually be on windows
        backup::_append_existent_paths /mnt/c/info
    else
        backup::_append_existent_paths /info
    fi

    # per-host
    if [[ "$host" == 'server-data' ]]; then
        :
        # TODO:
        # - music/etc on server
        # - : media filepath list
        #     find /srv/media -type f > /info/...
        # - wherever we store sync data
    fi
}

main()
{
    # env
    . ~/.restic/env

    case "$1" in
        backup)
            backup::backup
            ;;
        mount)
            backup::mount "${@:2}"
            ;;
        restic)
            backup::restic "${@:2}"
            ;;
        *)
            echo 'usage: '
            echo '  ~/.scripts/backup.sh backup'
            echo '  ~/.scripts/backup.sh restic <command>'
            echo '  ~/.scripts/backup.sh restic restic ls -l latest'
            echo '  ~/.scripts/backup.sh mount'
            echo '    # --no-default-permissions: to allow my user to access root files in the backup'
            ;;
    esac
}

main "$@"

# TODO: consider scheduling/nice
# 0 4 * * * ionice -c2 -n7 nice -n19 bash /root/backup.sh > /var/log/backup.log 2>&1
