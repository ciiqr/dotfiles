#!/usr/bin/env bash

set -e

# TODO: as needed
# declare script_dir
# script_dir="$(dirname "$(readlink -f ~/.local/bin/macro)")"

# TODO: configure nix
# NIX_EXTRA_CONF='
# experimental-features = nix-command flakes
# warn-dirty = false
# '
# TODO: OR: ~/.config/nix/nix.conf

# nix
if type nix >/dev/null 2>&1; then
    # update
    if [[ "$OSTYPE" == darwin* ]]; then
        sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
    fi
else
    # install
    # TODO: consider: --no-modify-profile
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# TODO: nix-darwin OR home-manager...
