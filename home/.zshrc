#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# mise
if command-exists mise; then
    eval "$(mise activate zsh)"
fi

# omz
plugins=(z)
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"
zstyle ':omz:lib:directories' aliases no
. source-if-exists ~/.oh-my-zsh/oh-my-zsh.sh

. source-if-exists ~/.shared_rc

# syntax-highlighting
. source-first-found \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# autosuggestions
. source-first-found \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ls auto complete colours
# created with: https://geoff.greer.fm/lscolors/
export LSCOLORS='exgxfxdxcxegedabagacad'
LS_COLORS='di=34:ln=36:so=35:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*:default' list-colors "$LS_COLORS"

# macos completions
# - base
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=(
        "${HOMEBREW_PREFIX}/share/zsh-completions"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        "${fpath[@]}"
    )
fi

# Completions
fpath=("$HOME/.zcompletions" "${fpath[@]}")

# precmd
_ciiqr_dotfiles_precmd() {
    # NOTE: not sure why the tab size resets 🤷
    tabs -4
}
typeset -ag precmd_functions
if [[ -z "${precmd_functions[(r)_ciiqr_dotfiles_precmd]}" ]]; then
    precmd_functions+=(_ciiqr_dotfiles_precmd)
fi

zstyle :compinstall filename "$HOME/.zshrc"

# TODO: fix colours so directories are blue not red...
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*' list-colors ''    # colour completions
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# TODO: Compile as applicable
# autoload -Uz zrecompile
# autoload zrecompile
# zrecompile "$ZDOTDIR" "$ZDOTDIR/functions"
# TODO: Maybe configure
# select-word-style

autoload -Uz compinit bashcompinit promptinit
# Completions
compinit -u
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
setopt extended_history  # record timestamp of command in HISTFILE
setopt hist_ignore_space # ignore commands that start with space
setopt hist_verify       # show command with history expansion to user before running it
setopt share_history     # share command history data

setopt interactive_comments

# completions
setopt list_packed         # Make the completion list smaller by printing the matches in columns with different widths
setopt no_complete_aliases # NOTE: despite the name, this actually enables aliases to be auto-completed as though it were the full command.

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
export WORDCHARS='_-|'

# Key Bindings
# NOTE: run `bindkey` to see all keybindings
bindkey -e # emacs
if [[ "$OSTYPE" == darwin* ]]; then
    # NOTE:
    # - get keybinding codes with: $ showkey
    # - print terminfo with: $ infocmp -1
    if [[ "$TERM_PROGRAM" == 'ghostty' ]]; then
        bindkey '\e[1;3A' beginning-of-line # alt + up
        bindkey '\e[1;3B' end-of-line # alt + down
        bindkey '\e[3;3~' kill-word # alt + delete
    elif [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
        bindkey '\e^[OA' beginning-of-line # alt + up
        bindkey '\e^[OB' end-of-line # alt + down
        bindkey '\e(' kill-word # alt + delete
    fi
fi

# Prompt
# - prompt fade <background> <text> <date>
case "$DOTFILES_MACHINE" in
    laptop-william)
        prompt fade magenta
        ;;
    *-william)
        prompt fade yellow black grey
        ;;
    *)
        prompt fade black grey white
        ;;
esac

# print partial line indicator (to prevent prompt clobbering final partial line of output)
# unsetopt prompt_cr
setopt PROMPT_CR
setopt PROMPT_SP
PROMPT_EOL_MARK='%B%K{red}%%%k%E'

# rosetta
if [[ "$OSTYPE" == darwin* && "$(uname -m)" != 'arm64' ]]; then
    RPROMPT='x86'
fi

# DEBUGGING PERFORMANCE
# zprof
