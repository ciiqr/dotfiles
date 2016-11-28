#!/usr/bin/env bash

# Usage
# git clone https://github.com/ciiqr/dotfiles.git ~/.dotfiles
# cd ~/.dotfiles
# ./install.sh --categories "personal development frontend"


# Functions
source_if_exists()
{
    if [[ -f "$1" ]]; then
        source "$1"
    else
        return 1
    fi
}

get_host_os()
{
    local host_os=''
    
    case "$OSTYPE" in
        darwin*)
            host_os='osx'
        ;;
        linux*)
            host_os='linux'
        ;;
    esac
    
    # Fall back to uname
    if [[ -z "$host_os" ]]; then
        host_os="`uname -s`"

        # Lower-case the result
        host_os="${host_os,,}"
    fi
    
    echo "$host_os"
}

transfer()
{
    local source_dir="$1"
    local destination_dir="$2"
    local backup_dir="$3"
    
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

set_cli_args_default()
{
    # TODO: Could change this to check if each of these is set before setting them this way we can call this method after parse_cli_args. Then we could do things like have a parameter for the hostname (without having to specify already specified categories) for things like preparing files on one machine before transfering them to another
    
    # categories: work/personal, server/desktop/media-centre, development
    case "$HOST_NAME" in
        desktop|laptop)
            categories=(personal desktop development)
            ;;
        server-data)
            categories=(personal server development)
            ;;
        server-family)
            categories=(personal server)
            ;;
        server-web)
            categories=(personal server)
            ;;
        *)
            categories=()
            ;;
    esac

    file_transfer_command="$TRANSFER_COPY_COMMAND"
    
    # TODO: Once I need mac support again, I'll need to support readlink without -f (NO, need to install brew, add the path to the path on osx only, and then install... Maybe include that here...)
    #   http://stackoverflow.com/a/1116890/1469823
    destination="$(readlink -f ~)"
    
    script_directory="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
    
    DEBUG=''
    
}

parse_cli_args()
{
    # index=0 # NOTE: Not currently needed
    while [[ $# -gt 0 ]]; do
        local arg="$1"

        case $arg in
            --categories)
                categories=($2)
                shift
            ;;
            --transfer)
                local transfer="$2"
                case $transfer in
                    copy)
                        file_transfer_command="$TRANSFER_COPY_COMMAND"
                    ;;
                    link)
                        file_transfer_command="$TRANSFER_LINK_COMMAND"
                    ;;
                    *)
                        # NOTE: This will not work properly if using a relative command path since we switch directories before running this command
                        file_transfer_command="$transfer"
                    ;;
                esac
                shift
            ;;
            --destination)
                destination="$(readlink -f "$2")"
                shift
            ;;
            --debug)
                # If this is specified then we won't actually do anything, but we will output the commands that we would
                # have run.
                DEBUG='echo DEBUG: '
            ;;
            *)
                echo $0: Unrecognized option $1
                return 1
            ;;
        esac
        shift # next
        # ((index++)) # NOTE: Not currently needed
    done
}

validate_args()
{
    if [[ -z "$categories" ]]; then
        echo $0: categories must be specified if not pre-defined by hostname
        exit 1
    fi

    if [[ ! -d "$destination" ]]; then
        echo $0: destination must be a directory
        exit 1
    fi
}

command_exists()
{
    type "$1" >/dev/null 2>&1
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

# Defines
# TRANSFER_COPY_COMMAND='cp -rf'
TRANSFER_COPY_COMMAND='rsync -ar'
TRANSFER_BACKUP_COMMAND='rsync -ar --ignore-existing'
TRANSFER_LINK_COMMAND='ln -sf'
HOST_NAME="`hostname`"
HOST_OS="`get_host_os`"
DATETIME=`date +%Y_%m_%d-%H_%M_%S`

# Main
shopt -s nullglob

require_programs readlink rsync hostname date || exit $?

set_cli_args_default
parse_cli_args "$@" || exit $?
validate_args || exit $?

# Setup

# TODO: Split out the backup step (and make a command )
# TODO: Would be nice to have all the source dirs before transferring (would make splitting out the backup step much easier, all we need to do is append the sources to an array that we just go over)
# TODO: might want to be able to specify comma (or otherwise) separated list as the depends folder name this way we can do things like 'depends/name/laptop,desktop/home/.zsh_prompt'
    # This has the benefit of reducing duplication but the own side of complicating how we source those customization directories... (still probably worth it)
# TODO: Add support for arbitrary params to pass to things like the development install script with my email...

# Create backup dir
backup="$script_directory/backup/$DATETIME"
$DEBUG mkdir -p "$backup"


# Transfer/Backup all files (order is important because it specifies precedence)

transfer "$script_directory/home" "$destination" "$backup"
transfer "$script_directory/depends/os/$HOST_OS/home" "$destination" "$backup"

for category in "${categories[@]}"; do
    transfer "$script_directory/depends/category/$category/home" "$destination" "$backup"
done

transfer "$script_directory/depends/name/$HOST_NAME/home" "$destination" "$backup"

    
# Custom setup
# NOTE: These are sourced for easy access to anything in this common install.sh

source_if_exists "$script_directory/depends/os/$HOST_OS/install.sh"

for category in "${categories[@]}"; do
    source_if_exists "$script_directory/depends/category/$category/install.sh"
done

source_if_exists "$script_directory/depends/name/$HOST_NAME/install.sh"


# Done
$DEBUG echo "Done! You will need to logout and back in before the \$PATH changes we've made will take effect"
