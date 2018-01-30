#!/usr/bin/env bash

set -e

forrealz(){ realpath "$@" 2>/dev/null || readlink -f "$@"; }
srcDir="$(dirname "$(forrealz "${BASH_SOURCE[0]}")")"

# download and run
if [[ "$srcDir" == '.' ]]; then
	tmp=$(mktemp -d)

	# download
	curl -sL 'https://github.com/ciiqr/config/archive/master.zip' -o "$tmp/config.zip"
	unzip -qq "$tmp/config.zip" -d "$tmp"

	# install
	"$tmp/config-master/scripts/install.sh"
	ret="$?"

	# cleanup
	# TODO: have an error handler to do this, possibly for the entire script
	[[ -d "$tmp" ]] && rm -r "$tmp"

	exit "$ret"
fi

. "$srcDir/include/common.sh"

# TODO: consider supporting non-root setup (will need to know from the salt states if root access is enabled)
ensureRoot

# TODO: params:
# - link
# - WorkstationDir
# - SaltDir

# TODO: if link, remove destination config dir, and link ../ to config dir
# TODO: else, download/etc zip https://github.com/ciiqr/config/archive/master.zip

# TODO: bootstrap salt, 2017.7, no service

# TODO: call setup-salt
# TODO: call provision
