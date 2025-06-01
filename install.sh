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

# umask
echo '==> configure umask'
# TODO: need a plugin for this
# TODO: do I even need the umask in ~/.shared_profile with this set?
if type 'launchctl' > /dev/null 2>&1; then
    sudo launchctl config user umask 002
    sudo launchctl config system umask 002
fi
umask 002

# install nk
curl -fsSL 'https://raw.githubusercontent.com/ciiqr/nk/HEAD/install.sh' | bash

# add to path
export PATH="${HOME}/.nk/bin:${PATH}"

# setup git hooks
if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == "true" ]]; then
    echo '==> setup git hooks'
    git config --local core.hookspath .hooks
fi

# configure machine
echo '==> configure machine'
nk var set machine "$machine"

# clear quarantine attributes (when downloading zips, macos will quarantine the
# files, and any files extracted from them)
if type 'xattr' > /dev/null 2>&1; then
    # TODO: don't use grep
    # TODO: find sources in .nk.yml file
    if xattr -r . ../dotfiles-private | grep -q com.apple.quarantine; then
        # TODO: only run on sources that exist
        xattr -r -d com.apple.quarantine . ../dotfiles-private || true
    fi
fi

# provision
echo '==> provision'
nk provision
