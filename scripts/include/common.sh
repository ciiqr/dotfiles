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
    gitRepo="$1"
    primaryUser="$2"

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
