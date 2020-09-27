#!/usr/bin/env bash

# TODO: add an option for excluding specific repos

readonly MAX_PAGES=100
readonly MAX_PARALLEL=32

usage()
{
    echo "usage: $0 organization|user <who> [<directory>]"
    echo "ie. $0 organization pentible ~/pentible"
    echo "ie. $0 user ciiqr ~/ciiqr"
    echo "  <directory>  will default to ./{who}"
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
        # get a page of repos from github
        declare output=$(get_page_of_repos | jq --raw-output '.[].ssh_url')

        # go until we get an empty page, or hit MAX_PAGES
        if [[ -z "$output" ]]; then
            break
        fi

        # append each repo to repositories
        while read -r repo; do
            repositories+=("$repo")
        done <<< "$output"
    done
}

if [[ "$#" -lt 1 || "$#" -gt 3 ]]; then
    usage
    exit 1
fi

declare subcommand="$1"
declare who="$2"
declare directory="${3:-./${who}}"

# ensure known subcommand
if [[ "$subcommand" != 'organization' && "$subcommand" != 'user' ]]; then
    usage
    exit 1
fi

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
        git clone "$repo" "${directory}/${repo_name}"

        # TODO: maybe make update optional?
        cd "${directory}/${repo_name}"
        git pull
    ) &

    max_bg_procs "$MAX_PARALLEL"
done

# pause until everything finishes
wait
