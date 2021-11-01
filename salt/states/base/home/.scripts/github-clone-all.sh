#!/usr/bin/env bash

set -e

readonly MAX_PAGES=100
readonly MAX_PARALLEL=32

usage()
{
    echo "usage: ~/.scripts/github-clone-all.sh organization|user <who> [<directory>] [--[no-]archived] [--[no-]pull] [--[no-]submodules]"
    echo "   ie. ~/.scripts/github-clone-all.sh organization pentible ~/pentible"
    echo "   ie. ~/.scripts/github-clone-all.sh user ciiqr ~/ciiqr"
    echo "  <directory>       will default to ./{who}"
    echo "  --[no-]archived   if not specified will include both archived and not archived repos"
    echo "  --[no-]pull       if not specified will default to no pull"
    echo "  --[no-]submodules if not specified will default to including submodules"
}

parse_cli_args()
{
    # TODO: add an option for excluding specific repos?

    declare -a positional=()

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --archived)
                include_archived='true'
            ;;
            --no-archived)
                include_archived='false'
            ;;
            --pull)
                pull_latest='true'
            ;;
            --no-pull)
                pull_latest='false'
            ;;
            --submodules)
                submodules='true'
            ;;
            --no-submodules)
                submodules='false'
            ;;
            -h|--help)
                usage
                exit 0
            ;;
            -*)
                echo "$0: unrecognized option $1" 1>&2
                usage 1>&2
                return 1
            ;;
            *)
                positional+=("$1")
            ;;
        esac
        shift
    done

    # ensure expected number of positional args
    if [[ "${#positional[@]}" -lt 2 || "${#positional[@]}" -gt 3 ]]; then
        echo "$0: unexpected number of positional arguments $1" 1>&2
        usage 1>&2
        return 1
    fi

    # assign positional args
    subcommand="${positional[0]}"
    who="${positional[1]}"
    directory="${positional[2]:-./${who}}"

    # ensure known subcommand
    if [[ "$subcommand" != 'organization' && "$subcommand" != 'user' ]]; then
        echo "$0: unrecognized subcommand $1" 1>&2
        usage 1>&2
        return 1
    fi
}

max_bg_procs()
{
    declare max="$1"
    while true; do
        declare current=$(jobs -pr | wc -l)
        if [[ $current -lt $max ]]; then
            break
        fi
        sleep 1
    done
}

get_page_of_repos()
{
    if [[ "$subcommand" == 'organization' ]]; then
        # organization repos
        github "/orgs/${who}/repos?page=${page}&per_page=100"
    elif [[ "$subcommand" == 'user' && "$who" == 'ciiqr' ]]; then
        # only repos I own
        github "/user/repos?page=${page}&per_page=100&affiliation=owner"
    elif [[ "$subcommand" == 'user' ]]; then
        # other users repos (both collabs and their public repos)
        declare collaborator="$(github "/user/repos?page=${page}&per_page=100&affiliation=collaborator" | jq ".[] | select(.owner.login == \"${who}\")")"
        declare public="$(github "/users/${who}/repos?page=${page}&per_page=100")"
        echo "$collaborator $public" | jq -s 'flatten'
    fi
}

github_repos()
{
    declare page=0
    while (( ++page <= MAX_PAGES )); do
        # get a page of repos from github (format as jsonl)
        declare repos="$(get_page_of_repos | jq -c '.[]')"

        # go until we get an empty page, or hit MAX_PAGES
        if [[ -z "$repos" ]]; then
            break
        fi

        # append each repo to repositories
        while read -r repo; do
            declare ssh_url=$(jq --raw-output '.ssh_url' <<< "$repo")
            declare archived=$(jq --raw-output '.archived' <<< "$repo")

            # skip if archived doesn't match param or param unset
            if [[ -n "$include_archived" && "$archived" != "$include_archived" ]]; then
                continue
            fi

            repositories+=("$ssh_url")
        done <<< "$repos"
    done
}

github()
{
    curl -s -H "Authorization: token $GITHUB_CLI_TOKEN" "https://api.github.com${1}" "${@:2}"
}

declare subcommand
declare who
declare directory
declare include_archived=''
declare pull_latest='false'
declare submodules='true'

parse_cli_args "$@"

# get all repos
declare -a repositories=()
github_repos

# make sure directory exists
mkdir -p "$directory"

# clone repos in parallel (up to MAX_PARALLEL at once)
for repo in "${repositories[@]}"; do
    # strip out the repo name
    declare repo_sans_ext=${repo%.git}
    repo_name="${repo_sans_ext/*:$who\/}"

    (
        # clone
        if [[ -d "${directory}/${repo_name}" ]]; then
            echo "- Repo '${directory}/${repo_name}' already exists"
        else
            git clone "$repo" "${directory}/${repo_name}"
        fi

        # pull latest
        if [[ "$pull_latest" == 'true' ]]; then
            cd "${directory}/${repo_name}"
            git pull
        fi

        # submodules
        if [[ "$submodules" == 'true' ]]; then
            cd "${directory}/${repo_name}"
            git submodule update --recursive --init
        fi
    ) &

    max_bg_procs "$MAX_PARALLEL"
done

# pause until everything finishes
wait
