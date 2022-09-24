. ~/.scripts/lib/colour.sh

output::header()
{
    output::echo 'yellow' '%' "$@"
}

output::success()
{
    output::echo 'black,bg::green' "$@"
}

output::failure()
{
    output::echo 'black,bg::red' "$@"
}

output::indent()
{
    # usage:
    # stdout: some_command | output::indent
    # stdout and stderr: { some_command 2>&1 1>&3 3>&- | output::indent; } 3>&1 1>&2 | output::indent

    # NOTE: indent all non-blank lines
    sed -E 's/^(.+)$/    \1/'
}

output::_colour_func_name()
{
    declare style="$1"

    case "$style" in
        # style with context specified (or contextless like bold)
        *::*|bold)
            echo "colour::${style}";;
        # default without context to foreground
        *)
            echo "colour::fg::${style}";;
    esac
}

output::_tput_custom_style()
{
    declare style="$1"

    case "$style" in
        # background context
        bg::*)
            tput setab "${style/bg::}";;
        # unknown context
        *::*)
            echo "output::echo: unknown style: ${style}"
            return 1
            ;;
        # default without context to foreground
        *)
            tput setaf "$style";;
    esac
}

output::echo()
{
    # USAGE: output::echo 'red,bold,bg::blue' "me"

    # TODO: consider having a way to force colour (env var, --color arg, etc.)

    # output is to tty
    if [[ -t 1 ]]; then
        # colourize
        declare IFS=,
        # NOTE: the echo is to make this split on IFS in zsh also
        for style in $(echo "$1"); do
            declare func
            func="$(output::_colour_func_name "$style")"
            if type "$func" >/dev/null 2>&1; then
                "$func"
            else
                # TODO: find custom colours with: ~/.scripts/tput-colours.sh
                output::_tput_custom_style "$style"
            fi
        done
    fi

    # echo actual content
    echo "${@:2}"

    # output is to tty
    if [[ -t 1 ]]; then
        colour::reset
    fi
}

# TODO: command to strip colour from text
# https://superuser.com/a/380778
# ie.
# Using GNU sed
# sed -e 's/\x1b\[[0-9;]*m//g'
# Using the macOS default sed
# sed -e $'s/\x1b\[[0-9;]*m//g'
