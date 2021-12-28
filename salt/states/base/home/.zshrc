#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# TODO: consider pulling this stuff into my config proper
. source-if-exists ~/.oh-my-zsh/lib/key-bindings.zsh
. source-if-exists ~/.oh-my-zsh/lib/termsupport.zsh

. source-if-exists ~/.shared_rc

# syntax-highlighting
. source-first-found \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggestions
# TODO: fix, currently showing up same colour as background
# . source-first-found \
#     /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

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

# case insensitive completion
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
# TODO: consider some options from: ~/.oh-my-zsh/lib/completion.zsh

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

# history
setopt hist_ignore_dups
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

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
