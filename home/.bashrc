#!/usr/bin/env bash

if [[ -z "$PS1" ]]; then
    return
fi

# direnv
if command-exists direnv; then
    eval "$(direnv hook bash)"
fi

. source-if-exists ~/.shared_rc

# completions
. source-first-found "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/bash_completion"

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
