#!/usr/bin/env bash

set -e

declare script_dir
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# install nk
curl -fsSL https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.sh | bash

# add to path
export PATH="${PATH}:${HOME}/.nk/bin"

# provision
cd "$script_dir"
nk provision
