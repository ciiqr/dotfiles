#!/usr/bin/env bash

set -e

git::usage()
{
    echo 'usage: '
    echo '  ~/.scripts/git.sh squash <count>'
    echo '  ~/.scripts/git.sh cmb <message> [<options>...]'
    echo '  ~/.scripts/git.sh new <branch>'
    echo '  ~/.scripts/git.sh anp <file>...'
    echo '  ~/.scripts/git.sh anpa'
    echo '  ~/.scripts/git.sh alias [<name>]'
    echo '  ~/.scripts/git.sh find-pending-changes-to-base <base> <file>...'
    echo '  ~/.scripts/git.sh external <repo>'
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
    read -r -p 'Proceed with squash? ' proceed
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
    git push -u origin @
}

git::anp()
{

    git -c "advice.addEmptyPathspec=false" add -N --ignore-removal "$@"
    git add -p "$@"
}

git::anpa()
{
    # NOTE: like 'git anp -A' except '-A' ignores the arguments telling it to ignore deleted files
    git -c "advice.addEmptyPathspec=false" add -N --ignore-removal .
    git add -p .
}

git::alias()
{
    git config --get-regexp "^alias\.($(IFS='|'; echo "$*"))" | sed 's/alias\.//' | less
}

git::find_pending_changes_to_base()
{
    # test if gh is authenticated
    if ! gh pr list >/dev/null 2>&1; then
        echo "gh not authenticated, can't check pr merge status"
        exit 1
    fi

    declare base="$1"
    while read -r branch; do
        # NOTE: git diff with ... shows only the files the branch changed
        # relative to it's commit merge base with the base branch. git lp with
        # ... shows all commits between these (ie. so if a branch is super out
        # of date, we won't compare all the commits for changes to a file, but
        # we will count all those for the lp count since here we specifically
        # want to know how out of sync they are with the base)

        if git diff --exit-code --quiet "origin/${base}...${branch}" -- "${@:2}" 2>/dev/null; then
            # skipping because diff between base and branch doesn't show changes for any of the provided files
            continue
        fi

        # TODO: verify that this actually helps (ie. wouldn't merged branches not show diffs? not sure that's true but that's the thesis to validate)
        # - probs mostly just branches that weren't merged into base?
        # TODO: origin/ wouldn't work with multiple/renamed upstreams...
        declare branch_name="${branch/'origin/'}"
        if [[ "$(gh pr view "$branch_name" --json 'closed' --jq '.closed' 2>/dev/null)" == 'true' ]]; then
            # skipping because branch has been merged and was simply not deleted
            continue
        fi

        # TODO: 200 commits is kinda arbitrary, may need to tweak
        # if there are less than 200 commits between (to filter out super outdated branches)
        if [[ "$(git log --oneline "origin/${base}...${branch}" | wc -l | awk '{print $1}')" -lt 200 ]]; then
            # print branch
            echo "$branch"
        fi

    done < <(git for-each-ref --format='%(refname)' refs/remotes \
        | sed 's@^refs/remotes/@@' \
        | grep -E -v "^origin/(${base}|HEAD)$"
    )
}

git::external()
{
    declare repo="$1"
    if [[ -z "$repo" ]]; then
        echo "usage: git external <repo>"
        echo "   ie. git external git@github.com:trpc/trpc.git"
        exit 1
    fi

    # extract directory path from repo
    # NOTE: sed doesn't support non-greedy matching, previously had: sed -E 's#^(https?://|git@)[^/:]+[/:]([^.]+)(\.git)?$#\2#g'
    declare directory
    directory="$(perl -pe 's#^(https?://|git@)[^/:]+[/:](.*?)(\.git)?$#\2#g' <<< "$repo")"

    # clone to ~/External
    git clone "$repo" "${HOME}/External/${directory}"
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
        anpa)
            git::anpa # "${@:2}"
            ;;
        alias)
            git::alias "${@:2}"
            ;;
        find-pending-changes-to-base)
            git::find_pending_changes_to_base "${@:2}"
            ;;
        external)
            git::external "${@:2}"
            ;;
        *)
            git::usage
            exit 1
            ;;
    esac
}

git::main "$@"
