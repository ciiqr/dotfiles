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
            case "$style" in
                # style with context specified (or contextless like bold)
                *::*|bold)
                    "colour::${style}";;
                # default without context to foreground
                *)
                    "colour::fg::${style}";;
            esac
        done
    fi

    # echo actual content
    echo "${@:2}"

    # output is to tty
    if [[ -t 1 ]]; then
        colour::reset
    fi
}
