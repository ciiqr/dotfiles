#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2> /dev/null)"

link_cleanup() {
    while read -r file; do
        # remove link
        if [[ -z "$file" ]]; then
            continue
        fi

        rm "$file" \
            || return "$(nk::error "$?" "failed removing link ${file}")"
        changed='true'
    done <<< "$(find "$resolved_path" -mindepth 1 -type l -exec test ! -e {} ";" -print)"
}

while read -r path; do
    # replace tilde
    declare resolved_path
    resolved_path="${path/#~/$HOME}"

    # provision
    declare status='success'
    declare changed='false'
    declare output=''
    if ! nk::run_for_output output link_cleanup; then
        status='failed'
    fi

    declare msg
    if [[ "$status" == 'failed' ]]; then
        msg="failed to clean up links in ${path}"
    else
        msg="cleaned up links in ${path}"
    fi

    # log state details
    nk::log_result \
        "$status" \
        "$changed" \
        "$msg" \
        "$output"
done <<< "$(jq -r --compact-output '.[].state')"
