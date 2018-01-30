#!/usr/bin/env bash

set -e

forrealz(){ realpath "$@" || readlink -f "$@"; }
srcDir="$(dirname "$(forrealz "${BASH_SOURCE[0]}")")"
echo "$srcDir"
