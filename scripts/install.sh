#!/usr/bin/env bash

set -e

forrealz(){ realpath "$@" 2>/dev/null || readlink -f "$@"; }
srcDir="$(dirname "$(forrealz "${BASH_SOURCE[0]}")")"
echo "$srcDir"
