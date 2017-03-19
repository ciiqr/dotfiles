#!/usr/bin/env bash

. common.sh

set_cli_args_default()
{
    # categories: work/personal, server/frontend, development
    case "$HOST_NAME" in
        desktop|laptop)
            categories=(personal frontend sublime development)
            ;;
        server-data)
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

    destination="$(readlink -f ~)"

    script_directory="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")"

    DEBUG=''

    no_auto_categories=''

    private_config_dir=''
}

parse_cli_args()
{
    while [[ $# -gt 0 ]]; do
        local arg="$1"

        case $arg in
            --categories)
                # Order is important because it specifies precedence for files which are in multiple categories...
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
                        # NOTE: This will not work properly if using a relative command path since we switch directories
                        # before running this command
                        file_transfer_command="$transfer"
                    ;;
                esac
                shift
            ;;
            --destination)
                destination="$(readlink -f "$2")"
                shift
            ;;
            --no-auto-categories)
                no_auto_categories="true"
            ;;
            --private-config)
                private_config_dir="$(readlink -f "$2")"
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

# Defines
TRANSFER_COPY_COMMAND='rsync -ar'
TRANSFER_BACKUP_COMMAND='rsync -ar --ignore-existing'
TRANSFER_LINK_COMMAND='ln -sf'
HOST_NAME="`hostname`"
HOST_OS="`get_host_os`"
DATETIME=`date +%Y_%m_%d-%H_%M_%S`

# Main
shopt -s nullglob

require_programs hostname date readlink rsync wget || exit $?

set_cli_args_default
parse_cli_args "$@" || exit $?
validate_args || exit $?

# Auto categories
if [[ -z "$no_auto_categories" ]]; then
    categories=("base" "$HOST_OS" "${categories[@]}" "$HOST_NAME")
fi

# Private config
if [[ -d "$private_config_dir" ]]; then
    . "$private_config_dir/config.sh" priv_conf categories
fi


# Setup
make_directory backup "$script_directory/.backup/$DATETIME"
make_directory home_backup "$backup/home"
make_directory temp_dir "$script_directory/.temp/$DATETIME"

# Transfer/Backup all files
for category in "${categories[@]}"; do
    transfer "$script_directory/$category/home" "$destination" "$home_backup"
done

# Custom setup
for category in "${categories[@]}"; do
    source_if_exists "$script_directory/$category/install.sh"
    [[ -d "$private_config_dir" ]] && source_if_exists "$private_config_dir/$category/dotfiles-install.sh"
done


# Tear down
destroy_directory temp_dir

$DEBUG echo "Done! You will need to logout and back in before the \$PATH changes we've made will take effect"
