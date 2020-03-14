#!/usr/bin/env bash

quiet()
{
    declare stdout=`mktemp`
    declare stderr=`mktemp`

    if ! "$@" </dev/null >"$stdout" 2>"$stderr"; then
        cat $stderr >&2
        rm -f "$stdout" "$stderr"
        return 1
    fi

    rm -f "$stdout" "$stderr"
}

if [[ $# -lt 2 ]]; then
    echo "usage: $0 <url> <versions>..."
    echo "ie. $0 https://github.com/amzn/amzn-drivers/archive/ena_linux_{{version}}.tar.gz 1.3.0 1.2.0 1.1.3 1.1.2"
    exit 1
fi

cmd="md5sum"
url="$1"
shift

# Create temp directory for all files
temp_dir="`mktemp -d`"

for version in "$@"; do
    # Build url
    version_url="${url//\{\{version\}\}/$version}"
    temp_file="$temp_dir/$version"

    # download file
    quiet wget -O "$temp_file" "$version_url"

    # hash file
    "$cmd" "$temp_file"

    # delete the file
    rm "$temp_file"
done

rmdir "$temp_dir"
