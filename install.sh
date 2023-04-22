#!/usr/bin/env bash

set -e

declare repo_dir
repo_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# go to repo directory
cd "$repo_dir"

# install nk
curl -fsSL 'https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.sh' | bash

# add to path
export PATH="${HOME}/.nk/bin:${PATH}"

# provision
echo '==> provision'
nk provision

# setup git hooks
if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
    echo '==> setup git hooks'
    git config --local core.hookspath .hooks
fi
