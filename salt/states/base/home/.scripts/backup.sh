#!/usr/bin/env bash

# NOTE: repo created with: restic init
# NOTE: for things that I intend to backup but have little need for locally, will either need to keep locally anyways, or have a separate host for storing those things (so they aren't attached to a host that's going to prune it's old stuff)

set -eo pipefail

# TODO: add a --dry-run parameter
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
    # TODO: consider printing paths...

    # actually backup data
    backup::_step 'backing up data'
    # TODO: add --exclude-file pointing to ~/.restic/exclude
    # - .DS_Store
    # - .localized
    # - desktop.ini
    # - *.swp
    # - .Trash
    # TODO: DOCS: https://github.com/restic/restic/blob/3a5c9aadada8efdf7dfb648dd23498108c794fbd/doc/040_backup.rst#excluding-files
    sudo -E restic backup "${paths[@]}"

    # prune
    backup::_step 'pruning old snapshots'
    # TODO: prune is slow, maybe it should be run less often...
    # restic forget --host "$host" --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 12

    # re-checking
    backup::_step 're-checking repo'
    restic check -q

    # notify finish
    send_notification 'Backup' 'Finished'
}

backup::mount()
{
    if backup::_is_osx; then
        declare backups_directory='/Volumes/backups'
    else
        declare backups_directory='/mnt/backups'
    fi

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
    grep -q 'Microsoft' '/proc/version' 2>/dev/null
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
    backup::_append_existent_paths ~/{.histfile,.bash_history,.python_history,.pythonhist,.macro/}
    # synced
    # TODO: may change ~/Documents to ~/Notes or something so windows/osx don't write garbage in there
    backup::_append_existent_paths ~/{Dropbox,Notes,Projects,Inbox,Screenshots,.wallpapers}

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

# TODO: anacron on linux frontend machines
# TODO: cron on linux server machines
# TODO: launchd on osx: https://stackoverflow.com/questions/132955/how-do-i-set-a-task-to-run-every-so-often
# TODO: task scheduler on windows (will need to run with bash)
