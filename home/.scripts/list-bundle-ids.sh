#!/usr/bin/env bash

set -e

declare all="$1"

list_application_paths() {
    if [[ "$all" == '--all' ]]; then
        mdfind -literal 'kMDItemContentType==com.apple.application-bundle'
    else
        find /Applications -mindepth 1 -maxdepth 1
    fi
}

get_app_id() {
    declare app_path="$1"
    declare plist_path="${app_path}/Contents/Info.plist"

    if [[ -f "$plist_path" ]]; then
        /usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$plist_path"
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
    bundle_id="$(get_app_id "$app_path")"
    if [[ -z "$bundle_id" ]]; then
        continue
    fi

    echo "- ${app_name}: ${bundle_id}"
done <<<"$(list_application_paths)"
