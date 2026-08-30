#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2> /dev/null)"


# TODO: updates or anything?
mise::_provision() {
    declare missing_count=0
    missing_count="$(
        mise ls --json | jq '[.[][] | select(.installed == false)] | length'
    )" \
        || return "$(nk::error "$?" 'failed checking missing count')"

    if (( missing_count > 0 )); then
        changed='true'
        cd ~ \
            || return "$(nk::error "$?" 'failed going home...')"
        mise install \
            || return "$(nk::error "$?" 'failed installing mise')"
    fi
}

# declare info="$2"

declare status='success'
declare changed='false'
declare output=''
if ! nk::run_for_output output mise::_provision; then
    status='failed'
fi

nk::log_result \
    "$status" \
    "$changed" \
    "mise install" \
    "$output"
