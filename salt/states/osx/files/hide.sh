#!/usr/bin/env bash

set -e

hex_to_decimal()
{
    echo "ibase=16; $@" | bc
}

declare command="$1"
declare path="$2"

declare changed='no'
declare comment=''

# stat flags
# $ grep UF /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/sys/stat.h
readonly UF_HIDDEN="$(hex_to_decimal 8000)"

# file not hidden
if [[ "$command" == 'hide' && "$(($(/usr/bin/stat -f "%f" "$path") & UF_HIDDEN))" == 0 ]]; then
    # hide
    chflags hidden "$path"

    # update state
    changed='yes'
    comment="${path}: was hidden"
elif [[ "$command" == 'show' && "$(($(/usr/bin/stat -f "%f" "$path") & UF_HIDDEN))" != 0 ]]; then
    # hide
    chflags nohidden "$path"

    # update state
    changed='yes'
    comment="${path}: was shown"
fi

# writing the state line
echo
echo "changed='${changed}' comment='${comment}'"
