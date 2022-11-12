#!/usr/bin/env bash

set -e

declare script_dir
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# install nk
curl -fsSL 'https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.sh' | bash

# add to path
export PATH="${PATH}:${HOME}/.nk/bin"

# TODO: remove once we support remote plugins?
# shellcheck disable=SC2154
if [[ ! -d ../nk-plugins && "$CODESPACES" == 'true' ]]; then
    echo '==> clone nk-plugins'
    git clone https://github.com/ciiqr/nk-plugins.git ../nk-plugins
    mkdir -p ../dotfiles-private
fi

echo '==> provision'

# provision
cd "$script_dir"
nk provision
