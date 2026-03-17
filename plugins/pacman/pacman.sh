#!/usr/bin/env bash

# TODO: move to nk-plugins

# NOTE: DOES NOT APPLY TO FUNCTIONS CALLED INSIDE IF CONDITIONS OR WITH ||/&& CHAINS
set -e

eval "$(nk plugin helper bash 2>/dev/null)"

pacman::_provision_package() {
    # ensure package exists
    if ! pacman -Si "$package"; then
        return 1
    fi

    # TODO: handle aur? or simply force use of chaotic?
    # TODO: obvs this code atm is silly, but it just needs to work
    # TODO: obvs relies on sudo without a prompt, should be fine under nk broadly
    if nk::array::contains "$package" "${outdated_packages[@]}"; then
        :
        # TODO: make the user read recent posts before upgrading
        # # upgrade
        # # TODO: doesn't this rely on -Sy tho? so it's kinda moot. Does nothing...
        # sudo pacman --sync --noconfirm --noprogressbar "$package" || return "$?"
        # changed='true'
        # action='update'
    elif ! nk::array::contains "$package" "${installed_packages[@]}"; then
        # install
        sudo pacman --sync --noconfirm --noprogressbar "$package" || return "$?"
        changed='true'
        action='install'
    fi
}

pacman::provision() {
    # collect list of all packages
    declare -a packages=()
    while read -r package; do
        # TODO: would be nice to preserve/check repo if provided
        packages+=("${package#*/}")
    done <<< "$(jq -r --compact-output '.[].state')"

    # TODO: decide, means needing to re-install everything right?
    # # update pacman (required to know about new versions of packages)
    # declare output=''
    # if ! nk::run_for_output output pacman -Syy; then
    #     # TODO: maybe just always log unchanged?
    #     # NOTE: only log if it fails
    #     declare status='failed'
    #     declare changed='false'
    #     declare description='pacman update'

    #     nk::log_result \
    #         "$status" \
    #         "$changed" \
    #         "$description" \
    #         "$output"
    # fi

    # list outdated packages
    # TODO: if we -Syy, we don't need to use checkupdates... decide
    # pacman-contrib -> checkupdates
    declare -a outdated_packages
    while read -r outdated_package; do
        outdated_packages+=("$outdated_package")
    done <<< "$(checkupdates | cut -f1 -d' ')"

    # list installed packages
    declare -a installed_packages
    while read -r installed_package; do
        installed_packages+=("$installed_package")
        # TODO: maybe --explicit? if we can force change new installes to explicit (even if they were already installed?)
    done <<< "$(pacman --query --quiet)"

    # provision packages
    for package in "${packages[@]}"; do
        declare action='install'

        declare status='success'
        declare changed='false'
        declare output=''
        if ! nk::run_for_output output pacman::_provision_package; then
            status='failed'
        fi

        nk::log_result \
            "$status" \
            "$changed" \
            "${action} package $package" \
            "$output"
    done

    # TODO: decide how to manage packages not explicitly listed in the config (update all? ignore? ...)

    # cleanup
    # TODO: https://wiki.archlinux.org/title/Pacman#Cleaning_the_package_cache
    # declare status='success'
    # declare output=''
    # if ! nk::run_for_output output pacman cleanup --prune=1; then
    #     status='failed'
    # fi

    # declare changed
    # if [[ "$output" == *'This operation has freed approximately'* ]]; then
    #     changed='true'
    # else
    #     changed='false'
    # fi

    # declare description="pacman cleanup"

    # # log state details
    # nk::log_result \
    #     "$status" \
    #     "$changed" \
    #     "$description" \
    #     "$output"
}

case "$1" in
    provision)
        pacman::provision "${@:2}"
        ;;
    *)
        echo "pacman: unrecognized subcommand ${1}" 1>&2
        exit 1
        ;;
esac
