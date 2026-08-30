#!/usr/bin/env bash

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2> /dev/null)"

# TODO: fix so it shows changed when it wasn't already initialized
# TODO: maybe should manage more about nvim? (occasional updates? lazy, mason, tree-sitter)
nvim::init::_provision() {
    mise exec -- nvim --headless \
        '+lua require("lazy").sync({ wait = true, lockfile = true })' \
        '+MasonToolsInstallSync' \
        +qa \
        || return "$(nk::error "$?" 'failed initializing nvim')"
}

# declare info="$2"

declare status='success'
declare changed='false'
declare output=''
if ! nk::run_for_output output nvim::init::_provision; then
    status='failed'
fi

nk::log_result \
    "$status" \
    "$changed" \
    "nvim initialized" \
    "$output"
