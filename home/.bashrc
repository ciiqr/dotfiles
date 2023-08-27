#!/usr/bin/env bash

if [[ -z "$PS1" ]]; then
    return
fi

# rtx
if command-exists rtx; then
    eval "$(rtx activate bash)"
fi

. source-if-exists ~/.shared_rc

# completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    . source-first-found "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

# Key Bindings
# NOTE: run `bind -p` to see all keybindings
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'
bind '"\e[3;5~":kill-word'

declare reset
reset="$(tput sgr0)"
export PS1="\[\033[38;5;11m\]\u\[${reset}\]@\h:\[${reset}\]\[\033[38;5;6m\][\w]\[${reset}\]: \[${reset}\]"

# History
HISTSIZE=101000
HISTFILESIZE=100000
shopt -s histappend

# Misc
shopt -s checkwinsize
shopt -s autocd
shopt -s extglob
