#!/usr/bin/env bash

set -e

declare repo_dir
repo_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# go to repo directory
cd "$repo_dir"

# args
declare machine="$1"
if [[ -z "$machine" ]]; then
    echo 'missing required argument: <machine>' >&2
    echo '  - laptop-william' >&2
    echo '  - work-william' >&2
    echo '  - server-data' >&2
    exit 1
fi

# install nk
curl -fsSL 'https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.sh' | bash

# add to path
export PATH="${HOME}/.nk/bin:${PATH}"

# setup git hooks
if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
    echo '==> setup git hooks'
    git config --local core.hookspath .hooks
fi

# configure machine
echo '==> configure machine'
nk var set machine "$machine"

# provision
echo '==> provision'
nk provision
