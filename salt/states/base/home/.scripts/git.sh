#!/usr/bin/env bash

set -e

git::usage()
{
    echo 'usage: '
    echo '  ~/.scripts/git.sh squash <count>'
    echo '  ~/.scripts/git.sh cmb <message> [<options>...]'
    echo '  ~/.scripts/git.sh new <branch>'
    echo '  ~/.scripts/git.sh anp <file>...'
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
    git show \
        --color \
        --pretty=mono \
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

git::cmb()
{
    git cm "$(git branch --show-current): $1" "${@:2}"
}

git::new()
{
    if [[ "$#" != 1 ]]; then
        git::usage
        exit 1
    fi

    declare name="$1"

    git checkout -b "$name"
    git push -u origin "$name"
}

git::anp()
{
    git -c "advice.addEmptyPathspec=false" add -N --ignore-removal "$@"
    git add -p "$@"
}

git::main()
{
    case "$1" in
        squash)
            git::squash "${@:2}"
            ;;
        cmb)
            git::cmb "${@:2}"
            ;;
        new)
            git::new "${@:2}"
            ;;
        anp)
            git::anp "${@:2}"
            ;;
        *)
            git::usage
            exit 1
            ;;
    esac
}

git::main "$@"
