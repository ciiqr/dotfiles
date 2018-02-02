usage()
{
    echo "usage: $1 [--force] [--link|--copy] [--roles <roles>] [--configDir <configDir>] [--privateConfigDir <privateConfigDir>] [--saltDir <saltDir>]" 1>&2
    exit 1
}

set_cli_args_default()
{
    force="false"
    link="true"
    configDir="/config"
    privateConfigDir="/config-private"
    saltDir="/etc/salt"
    roles=""
}

parse_cli_args()
{
    set_cli_args_default

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --link)
                link="true"
            ;;
            --copy)
                link="false"
            ;;
            --configDir)
                configDir="${2%/}"
                shift
            ;;
            --privateConfigDir)
                privateConfigDir="${2%/}"
                shift
            ;;
            --saltDir)
                saltDir="${2%/}"
                shift
            ;;
            --roles)
                roles="$2"
                shift
            ;;
            --force)
                force="true"
            ;;
            -h|--help)
                return 1
            ;;
            *)
                echo "$0: Unrecognized option $1" 1>&2
                return 1
            ;;
        esac
        shift
    done
}

ensureRoot()
{
    if [[ "$EUID" -ne 0 ]]; then
       echo "must be run as root" 1>&2
       exit 1
    fi
}
