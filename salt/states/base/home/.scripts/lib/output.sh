. ~/.scripts/lib/colour.sh

output::header()
{
    # TODO: consider having a way to force colour (env var, --color arg, etc.)

    # output is to tty
    if [[ -t 1 ]]; then
        colour::fg::yellow
    fi

    echo '%' "$@"

    # output is to tty
    if [[ -t 1 ]]; then
       colour::reset
    fi
}

output::indent()
{
    # NOTE: indent all non-blank lines
    sed -E 's/^(.+)$/    \1/'
}
