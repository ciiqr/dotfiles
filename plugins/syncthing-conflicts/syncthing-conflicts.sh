#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2>/dev/null)"

declare status='success'
declare changed='false'
declare output=''
if ! nk::run_for_output output find ~/{Docs,Projects,Screenshots,.wallpapers,.archive,.backup} -iname "*.sync-conflict-*"; then
    status='failed'
fi

# if any files were found, we fail
if [[ -n "$output" ]]; then
    status='failed'
fi

nk::log_result \
    "$status" \
    "$changed" \
    "syncthing-conflicts" \
    "$output"
