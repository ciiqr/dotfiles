#!/usr/bin/env bash

. ~/.scripts/lib/colour.sh

output::header() {
    output::echo 'yellow' '%' "$@"
}

output::success() {
    output::echo 'black,bg::green' "$@"
}

output::failure() {
    output::echo 'black,bg::red' "$@"
}

output::indent() {
    # usage:
    # stdout: some_command | output::indent
    # stdout and stderr: { some_command 2>&1 1>&3 3>&- | output::indent; } 3>&1 1>&2 | output::indent

    # NOTE: indent all non-blank lines
    sed -E 's/^(.+)$/    \1/'
}

output::_colour_func_name() {
    declare style="$1"

    case "$style" in
        # style with context specified (or contextless like bold)
        *::* | bold)
            echo "colour::${style}"
            ;;
        # default without context to foreground
        *)
            echo "colour::fg::${style}"
            ;;
    esac
}

output::_tput_custom_style() {
    declare style="$1"

    case "$style" in
        # background context
        bg::*)
            tput setab "${style/bg::/}"
            ;;
        # unknown context
        *::*)
            echo "output::echo: unknown style: ${style}"
            return 1
            ;;
        # default without context to foreground
        *)
            tput setaf "$style"
            ;;
    esac
}

output::echo() {
    # USAGE: output::echo 'red,bold,bg::blue' "me"

    # output is to tty
    if [[ -t 1 || "${CLICOLOR_FORCE:-}" == '1' ]]; then
        # colourize
        declare IFS=,
        for style in $1; do
            declare func
            func="$(output::_colour_func_name "$style")"
            if type "$func" >/dev/null 2>&1; then
                "$func"
            else
                # NOTE: find custom colours with: ~/.scripts/colours.sh
                output::_tput_custom_style "$style"
            fi
        done
    fi

    # echo actual content
    echo "${@:2}"

    # output is to tty
    if [[ -t 1 || "${CLICOLOR_FORCE:-}" == '1' ]]; then
        colour::reset
    fi
}
