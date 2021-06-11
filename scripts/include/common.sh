usage()
{
    echo "usage: $1 [--machine <machine>] [--roles <roles>] [--configDir <configDir>] [--privateConfigDir <privateConfigDir>] [--saltDir <saltDir>] [--primaryUser <primaryUser>]" 1>&2
    exit 1
}

set_cli_args_default()
{
    saltDir="/etc/salt"
    # TODO: could default to hostname... gotta change machine vs roles check below, should be fine otherwise
    # TODO: maybe also default configDir based on script (and private assuming adjacent to config...)
    machine=""
    roles=""
    primaryUser=""
}

parse_cli_args()
{
    set_cli_args_default

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
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
            --machine)
                machine="$2"
                shift
            ;;
            --roles)
                roles="$2"
                shift
            ;;
            --primaryUser)
                primaryUser="$2"
                shift
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

    # post defaults
    declare user="${primaryUser:-$(logname)}"
    if [[ -z "$configDir" ]]; then
        configDir="$(eval echo ~$user)/Projects/config"
    fi
    if [[ -z "$privateConfigDir" ]]; then
        privateConfigDir="$(eval echo ~$user)/Projects/config-private"
    fi

    checkCliArgErrors
}

checkCliArgErrors()
{
    if [[ -n "$machine" ]] && [[ -n "$roles" ]]; then
        echo 'cannot specify both machine and roles' >&2
        exit 1
    fi
}

ensureRoot()
{
    if [[ "$EUID" -ne 0 ]]; then
       echo "must be run as root" 1>&2
       exit 1
    fi
}

download()
{
    if type curl >/dev/null 2>&1; then
        # TODO: -s is kinda awful...
        curl -sL "$@"
    elif type wget >/dev/null 2>&1; then
        wget -O - "$@"
    else
        echo "no download command found" 1>&2
        exit 1
    fi
}

machineMatches()
{
    declare machine="$(salt-call grains.get id --out newline_values_only)"

    grep -q "^$machine:" "$saltDir/machines.yaml"
}
