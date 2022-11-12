#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin bash 2>/dev/null)"

nix_cli::_provision_nix() {
    declare destination="${HOME}/.config/nvim/autoload/plug.vim"
    declare plug_vim_url='https://raw.githubusercontent.com/junegunn/vim-plug/HEAD/plug.vim'

    declare source_contents
    source_contents="$(curl -fsSL "$plug_vim_url")" \
        || return "$(nk::error "$?" "failed downloading ${plug_vim_url}")"
    declare destination_contents
    destination_contents="$(cat "$destination" 2>/dev/null)" # failures intentionally ignored

    if [[ ! -f "$destination" || "$destination_contents" != "$source_contents" ]]; then
        # create parent directory
        declare parent_directory
        parent_directory="$(dirname "$destination")"
        if [[ ! -d "$parent_directory" ]]; then
            mkdir -p "$parent_directory" \
                || return "$(nk::error "$?" "failed creating ${parent_directory}")"
            changed='true'
        fi

        # install
        cat <<<"$source_contents" >"$destination" \
            || return "$(nk::error "$?" "failed creating ${destination}")"
        changed='true'

        # plug install
        nvim --headless +PlugInstall +PlugUpgrade +PlugUpdate +qall \
            || return "$(nk::error "$?" 'failed installing plugins')"
    fi
}

declare status='success'
declare changed='false'
declare output=''
if ! nk::run_for_output output nix_cli::_provision_nix; then
    status='failed'
fi

nk::log_result \
    "$status" \
    "$changed" \
    "install vim-plug" \
    "$output"
