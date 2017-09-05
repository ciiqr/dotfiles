#!/usr/bin/env bash

source_if_exists()
{
    if [[ -f "$1" ]]; then
        source "$1"
    else
        return 1
    fi
}

command_exists()
{
    type "$1" >/dev/null 2>&1
}

contains_option()
{
    local needle="$1"
    shift
    declare -a options=("$@")

    for option in "${options[@]}"; do
        if [[ "$option" == "$needle" ]]; then
            return 0
        fi
    done

    return 1
}

make_directory()
{
    declare -g "$1"="$2"
    $DEBUG mkdir -p "${!1}"
}

destroy_directory()
{
    $DEBUG rm -r "${!1}"
    unset "$1"
}

require_programs()
{
    for program in "$@"; do
        if ! command_exists "$program"; then
            echo $0: missing required program "$program"
            return 1
        fi
    done
}

get_host_os()
{
    local host_os=''

    local possible_oses=("$OSTYPE" "`uname -s`")
    for possible_os in "${possible_oses[@]}"; do
        case "${possible_os,,}" in
            darwin*)
                host_os='osx'
                break
            ;;
            linux*)
                host_os='linux'
                break
            ;;
            cygwin|msys)
                host_os='windows'
                break
            ;;
            *)
                # NOTE: If we don't find a match, we'll just use whatever we can
                host_os="${possible_os,,}"
            ;;
        esac
    done

    echo "$host_os"
}

transfer()
{
    local source_dir="$1"
    local destination_dir="$2"
    local backup_dir="$3"

    # Ensure the destination_dir always exists
    $DEBUG mkdir -p "$destination_dir"

    pushd "$source_dir" >/dev/null 2>&1 || return 1

        local file
        for file in {.,}*; do
            if [[ $file == '.' ]] || [[ $file == '..' ]]; then
                continue
            fi

            # TODO: switch to relative_source_dir (or more reasonably have option so we can use either absolute or relative path for the transfer command), except that we need this to work properly with cp as well, so we're probably going to need some functions wrapping all of this so copy can use the fullpaths and link the relative paths
            # relative_source_dir="$(relative_path "$source_dir")" TODO: (common parent? home directory? assume destination is parent? http://stackoverflow.com/a/2565106/1469823?)
            local source_file="$source_dir/$file"
            local destination_file="$destination_dir/$file"
            local backup_file="$backup_dir/$file"

            # Prepent trailing slash to source directory so rsync transfers as we expect it to
            if [[ -d "$source_file" ]]; then
                source_file="$source_file/"
            fi

            # Prepent trailing slash to source directory so rsync transfers as we expect it to
            if [[ -d "$destination_file" ]]; then
                destination_file="$destination_file/"
            fi

            # Back up the old version (only if it exists already and hasn't already been backed up)
            if [[ -e "$destination_file" ]] && [[ ! -e "$backup_file" ]]; then
                $DEBUG $TRANSFER_BACKUP_COMMAND "$destination_file" "$backup_file"
            fi

            $DEBUG $file_transfer_command "$source_file" "$destination_file"
            # TODO: May want to set permissions/owner on the destination files, have an optional way of doing so at least

        done

    popd >/dev/null 2>&1
}

join_by()
{
    local d=$1
    shift
    echo -n "$1"
    shift
    printf "%s" "${@/#/$d}"
}

json_string_array()
{
    declare -a arr=("$@")
    if [[ ${#arr[@]} -eq 0 ]]; then
        echo '[]'
    else
        echo '["'`join_by '","' "${arr[@]}"`'"]'
    fi
}

escape_for_sed()
{
    sed -e 's@/@\\\/@g'
}

download_to()
{
    # TODO: Fall back to curl if wget doesn't exist
    local wget_error_log
    wget_error_log=$($DEBUG wget -nv "$1" -O "$2" 2>&1)
    local retval="$?"

    if [[ "$retval" -ne "0" || ! -z "$DEBUG" ]]; then
        echo "$wget_error_log"
    fi

    return "$retval"
}

quiet()
{
    declare stdout=`(tempfile || mktemp) 2>/dev/null`
    declare stderr=`(tempfile || mktemp) 2>/dev/null`

    if ! "$@" </dev/null >"$stdout" 2>"$stderr"; then
        cat $stderr >&2
        rm -f "$stdout" "$stderr"
        return 1
    fi

    rm -f "$stdout" "$stderr"
}
