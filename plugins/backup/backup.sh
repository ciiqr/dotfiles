#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2>/dev/null)"

backup::_provision_backup() {
    declare backup_dir="${HOME}/.backup"
    if [[ ! -d "$backup_dir" ]]; then
        return "$(nk::error '1' "backup directory missing: ${backup_dir}")"
    fi

    # backing up vscode configs
    declare vscode_backup_dir="${HOME}/Projects/dotfiles/vscode"
    if [[ -d "$vscode_backup_dir" ]] && type code >/dev/null 2>&1; then
        echo '==> backing up vscode configs'
        declare -a vscode_configs=(
            "${HOME}/Library/Application Support/Code/User/keybindings.json"
            "${HOME}/Library/Application Support/Code/User/settings.json"
        )

        # enforce trailing newline (which vscode sync drops)
        for config in "${vscode_configs[@]}"; do
            if [[ -n "$(tail -c 1 "$config")" ]]; then
                # append newline
                echo >>"$config"
            fi
        done

        cp "${vscode_configs[@]}" "${vscode_backup_dir}/"
        code --list-extensions >"${vscode_backup_dir}/extensions.txt"
    else
        echo '==> NOT backing up vscode configs (destination not found)'
    fi

    # backing up everything else
    echo '==> backing up everything else'
    rsync -avh --delete \
        --include='.histfile' \
        --include='.bash_history' \
        --include='.macro/' \
        --include='.macro/**' \
        --exclude='*' \
        "${HOME}/" "${backup_dir}/${machine}"
}

declare info="$2"

declare machine
machine="$(jq -r --compact-output --exit-status '.vars.machine' <<<"$info")"

declare status='success'
declare changed='false'
declare output=''
if ! nk::run_for_output output backup::_provision_backup; then
    status='failed'
fi

nk::log_result \
    "$status" \
    "$changed" \
    "backup" \
    "$output"
