#!/usr/bin/env bash

set -e

hex_to_decimal()
{
    echo "ibase=16; $@" | bc
}

declare changed='no'
declare comment=''

# stat flags
# $ grep UF /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/sys/stat.h
readonly UF_HIDDEN="$(hex_to_decimal 8000)"

# file not hidden
if [[ "$(($(/usr/bin/stat -f "%f" "$1") & UF_HIDDEN))" == 0 ]]; then
    # hide
    chflags hidden "$1"

    # update state
    changed='yes'
    comment="$1: was hidden"
fi

# writing the state line
echo
echo "changed='${changed}' comment='${comment}'"
