#!/usr/bin/env bash

set -e

git::usage()
{
    echo 'usage: '
    echo '  ~/.scripts/git.sh squash <count>'
}

git::squash()
{
    if [[ "$#" != 1 ]]; then
        git::usage
        exit 1
    fi

    declare count="$1"

    # TODO: idk if we can add a check for this automatically but:
    # - if commit count shown doesn't match, may be a hint that the squash number is too high

    # preview squash
    # TODO: this is the same format I use for lp alias, can we move this somewhere common?
    git show \
        --color \
        --pretty=format:"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)" \
        --relative-date \
        --decorate \
        --name-status \
        "HEAD...HEAD~${count}"

    # prompt to proceed
    read -p 'Proceed with squash? ' proceed
    if [[ 'yes' != "$proceed"* ]]; then
        echo 'squash cancelled'
        exit 1
    fi

    # squash
    git reset --soft "HEAD~${count}"
    git commit --edit -m "$(git log --format='%B' --reverse 'HEAD...HEAD@{1}')" --no-verify
}

git::main()
{
    case "$1" in
        squash)
            git::squash "${@:2}"
            ;;
        *)
            git::usage
            exit 1
            ;;
    esac
}

git::main "$@"
