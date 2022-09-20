#!/usr/bin/env bash

set -e

# TODO: make proper interface
declare all="$1"

list_application_paths()
{
    if [[ "$all" == '--all' ]]; then
        mdfind -literal kMDItemContentType=="com.apple.application-bundle"
    else
        find /Applications -mindepth 1 -maxdepth 1
    fi
}

while read -r app_path; do
    declare app_file
    app_file="$(basename "$app_path")"
    declare app_name="${app_file%.app}"
    if [[ "$app_path" != *'.app' ]]; then
        continue
    fi

    declare bundle_id
    bundle_id="$(osascript -e "id of app \"${app_path}\"")"
    if [[ -z "$bundle_id" || "$bundle_id" == '????' ]]; then
        continue
    fi

    echo "- ${app_name}: ${bundle_id}"
done <<< "$(list_application_paths)"
