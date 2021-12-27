#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# TODO: I don't think I'm actually making use of any omz features atm, test without for a while and remove?
# TODO: seems keybindings break without this, need to fix
. source-if-exists ~/.omzshrc

. source-if-exists ~/.shared_rc

# Syntax Highlighting
. source-first-found \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# TODO: ugh, shouldn't have to have this here...
# osx completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=(
        "${HOMEBREW_PREFIX}/share/zsh-completions"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        $fpath
    )
fi

# Custom completions
fpath=("$HOME/.zcompletions" $fpath)

zstyle :compinstall filename "$HOME/.zshrc"

# TODO: Compile as applicable
# autoload -Uz zrecompile
# autoload zrecompile
# zrecompile "$ZDOTDIR" "$ZDOTDIR/functions"
# TODO: Maybe configure
# select-word-style

autoload -Uz compinit bashcompinit promptinit
# Completions
compinit
bashcompinit
# Prompt
promptinit

# Glob's without any matches are sent to the command as is
unsetopt no_match

setopt auto_cd
setopt auto_push_d
setopt push_d_ignore_dups

setopt hist_ignore_dups
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_reduce_blanks

setopt interactive_comments

# Make the completion list smaller by printing the matches in columns with different widths
setopt list_packed

# NOTE: despite the name, this actually enables aliases to be auto-completed as though it were the full command.
setopt no_complete_aliases

setopt no_rm_star_silent
setopt print_exit_value

# Disable printing of ^C and related control commands
stty -ctlecho

# automatically remove duplicates from these arrays
typeset -gU path cdpath manpath fpath

HISTFILE="${HOME}/.histfile"
HISTSIZE=101000
SAVEHIST=100000
LISTMAX=0 # only show the following prompt if doing so would scroll 'do you wish to see all NNN possibilities?'
export WORDCHARS=_-\|

. source-all-from ~/.zshrc.d

# DEBUGGING PERFORMANCE
# zprof
