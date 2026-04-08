#!/usr/bin/env bash

set -e

if [[ "$OSTYPE" == 'darwin'* ]]; then
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
    done <<< "$(list_application_paths)"
else # linux
    # find all app directories
    declare -a app_directories=(
        # user applications directory
        "${XDG_DATA_HOME:-$HOME/.local/share}/applications"
    )

    if [[ -n "$XDG_DATA_DIRS" ]]; then
        # system application directories
        declare xdg_data_dirs
        IFS=':' read -ra xdg_data_dirs <<< "$XDG_DATA_DIRS"

        declare dir
        for dir in "${xdg_data_dirs[@]}"; do
            app_directories+=("${dir}/applications")
        done
    else
        # default system application directories
        app_directories+=(
            "/usr/local/share/applications"
            "/usr/share/applications"
        )
    fi

    # list all app paths
    find "${app_directories[@]}" \
        -mindepth 1 \
        -maxdepth 1 \
        -name '*.desktop' \
        -printf "%f\n" \
        2> /dev/null \
        | sed 's/\.desktop$//' | sort | uniq
fi
