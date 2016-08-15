#!/usr/bin/env bash

# Usage
# git clone https://github.com/ciiqr/dotfiles.git ~/.dotfiles
# cd ~/.dotfiles
# ./install.sh --categories "personal development frontend"


# Functions
array_contains()
{
    local array="$1[@]"
    local seeking=$2
    local in=1
    local element
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
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

set_cli_args_default()
{
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
    
    # TODO: Once I need mac support again, I'll need to support readlink without -f
    #   http://stackoverflow.com/a/1116890/1469823
    destination="$(readlink -f ~)"
    
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


# Defines
TRANSFER_COPY_COMMAND='cp -rf'
TRANSFER_LINK_COMMAND='ln -sf'
SCRIPT_DIRECTORY="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"
HOST_NAME="`hostname`"
HOST_OS="`get_host_os`"

# Main
set_cli_args_default
parse_cli_args "$@" || exit $?

starting_directory="`pwd`"

if [[ -z "$categories" ]]; then
    echo $0: categories must be specified if not pre-defined by hostname
    exit 1
fi

if [[ ! -d "$destination" ]]; then
    echo $0: destination must be a directory
    exit 1
fi

# Setup

# Move all home files
source_directory="$SCRIPT_DIRECTORY/home"
# relative_source_directory="$(relative_path "$source_directory")" TODO: (common parent? home directory? assume destination is parent? http://stackoverflow.com/a/2565106/1469823?)
pushd "$source_directory" 1>/dev/null
    for file in {.,}*; do
        if [[ $file == '.' ]] || [[ $file == '..' ]] || [[ $file == '*' ]]; then
            continue
        fi
        
        # We switch to the starting directory in case we need to specify a relative transfer command not on the path
        pushd "$starting_directory" 1>/dev/null
            # TODO: switch to relative_source_directory, except that we need this to work properly with cp as well, so we're probably going to need some functions wrapping all of this so copy can use the fullpaths and link the relative paths
            source_file="$source_directory/$file"
            
            $DEBUG $file_transfer_command "$source_file" "$destination/"
            # TODO: May want to set permissions/owner on the destination files, have an optional way of doing so at least
        popd 1>/dev/null
        
    done
popd 1>/dev/null


# Run all one time setup

if array_contains categories development; then
    # Git
    $DEBUG git config --global user.name "William Villeneuve"
    # TODO: $DEBUG git config --global user.email "user@example.com"
    $DEBUG git config --global alias.cm '!git commit -m'
    $DEBUG git config --global alias.st status
    $DEBUG git config --global alias.co checkout
    $DEBUG git config --global alias.br branch
fi
