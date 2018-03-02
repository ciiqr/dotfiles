usage()
{
    echo "usage: $1 [--force] [--link|--copy] [--machine <machine>] [--roles <roles>] [--configDir <configDir>] [--privateConfigDir <privateConfigDir>] [--saltDir <saltDir>] [--primaryUser <primaryUser>]" 1>&2
    exit 1
}

set_cli_args_default()
{
    force="false"
    link="true"
    configDir="/config"
    privateConfigDir="/config-private"
    saltDir="/etc/salt"
    machine=""
    roles=""
    primaryUser=""
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

confirm()
{
    if [[ "$force" == "true" ]]; then
        return
    fi

    echo -n "$@" "[Ny]?" 1>&2
    read -p " " -r
    [[ $REPLY =~ ^[Yy]$ ]]
    return $?
}

tryGitUpdate()
{
    declare gitRepo="$1"
    declare primaryUser="$(salt-call grains.get primaryUser --out newline_values_only)"

    if [[ ! -d "$gitRepo/.git" ]]; then
        echo 'warning: Local "$gitRepo" is not a git repository, skipping update'
        return 0
    fi

    su "$primaryUser" <<EOF

    # update remotes
    cd "$gitRepo"
    git fetch --all

    # check if we can update (no untracked/staged changes, and our local is behind remote)
    local_rev="\$(git rev-parse @)"
    remote_rev="\$(git rev-parse "@{u}")"
    base_rev="\$(git merge-base @ "@{u}")"
    if [[ -z "\$(git status -s)" && "\$local_rev" != "\$remote_rev" && "\$local_rev" == "\$base_rev" ]]; then
        git rebase @{u} || {
            echo 'warning: Local "$gitRepo" failed updating, skipping update'
            git rebase --abort
        }
    else
        echo 'warning: Local "$gitRepo" has diverged, skipping update'
    fi
EOF
}

notify()
{
    declare title="$1"
    declare message="$2"
    declare primaryUser="$(salt-call grains.get primaryUser --out newline_values_only)"

    if [[ "$OSTYPE" == darwin* ]]; then
        sudo -u "$primaryUser" osascript -e 'on run argv
            display notification (item 2 of argv) with title (item 1 of argv)
        end run' "$title" "$message"
    else
        # get required env vars
        environ_sleuth "$primaryUser" "DBUS_SESSION_BUS_ADDRESS"

        su "$primaryUser" -c "notify-send '$title' '$message'"
    fi
}

environ_sleuth()
{
    # NOTE: this finds env vars for other processes and exports them here

    declare user="$1"
    declare filter="$2"

    while read -r pid; do
        if egrep -q '^('"$filter"')=' "/proc/$pid/environ"; then
            eval export $(tr '\0' '\n' < /proc/$pid/environ | egrep '^('"$filter"')=')
            break
        fi
    done < <(pgrep -u "$user")
}

machineMatches()
{
    declare machine="$(salt-call grains.get id --out newline_values_only)"

    grep -q "^$machine:" "$saltDir/machines.yaml"
}
