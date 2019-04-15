#!/usr/bin/env bash

# TODO: add an option for prefixing the repo dirs

readonly MAX_PAGES=100
readonly MAX_PARALLEL=32

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

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
    echo "usage: $0 <org> [<directory>]"
    echo "ie. $0 pentible ~/pentible"
    echo "  <directory>  will default to ./{org}"
    exit 1
fi

declare org="$1"
declare directory="${2:-./${org}}"

declare -a repositories=()

# get all repos
declare page=0
while (( ++page <= MAX_PAGES )); do
    # get a page of repos from github
    # TODO: should be able to support my own repos with: github "/user/repos?affiliation=owner"
    declare output=$(github "/orgs/${org}/repos?page=${page}&per_page=100" | jq --raw-output '.[].ssh_url')

    # go until we get an empty page, or hit MAX_PAGES
    if [[ -z "$output" ]]; then
        break
    fi

    # append each repo to repositories
    while read -r repo; do
        repositories+=("$repo")
    done <<< "$output"
done

# make sure directory exists
mkdir -p "$directory"

# clone repos in parallel (up to MAX_PARALLEL as once)
for repo in "${repositories[@]}"; do
    # strip out the repo name
    declare repo_sans_ext=${repo%.git}
    repo_name="${repo_sans_ext/*:$org\/}"

    git clone "$repo" "${directory}/${repo_name}" &
    max_bg_procs "$MAX_PARALLEL"
done

# pause until everything finishes
wait
