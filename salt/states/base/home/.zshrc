#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# direnv
if command-exists direnv; then
    eval "$(direnv hook zsh)"
fi

# TODO: consider pulling this stuff into my config proper
. source-if-exists ~/.oh-my-zsh/lib/key-bindings.zsh
. source-if-exists ~/.oh-my-zsh/lib/functions.zsh
. source-if-exists ~/.oh-my-zsh/lib/termsupport.zsh

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# osx completions
# - base
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=(
        "${HOMEBREW_PREFIX}/share/zsh-completions"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        $fpath
    )
fi
# - google cloud
. source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Completions
fpath=("$HOME/.zcompletions" $fpath)

zstyle :compinstall filename "$HOME/.zshrc"


# TODO: consider some options from: ~/.oh-my-zsh/lib/completion.zsh
# case insensitive completion
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'

# TODO: fix colours so directories are blue not red...
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*' list-colors '' # colour completions
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'


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

# completions
setopt list_packed # Make the completion list smaller by printing the matches in columns with different widths
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
bindkey '^H' backward-kill-word
if ~/.scripts/system.sh is-osx; then
    if [[ "$TERM" == 'xterm'* ]]; then
        bindkey '\e^[OA' beginning-of-line # alt + up
        bindkey '\e^[OB' end-of-line       # alt + down
        bindkey '\e('    kill-word         # alt + delete
    fi
fi

# Prompt
case "$DOTFILES_HOSTNAME" in
desktop-william|laptop-william)
    # prompt fade <background> <text> <date>
    # prompt fade blue
    prompt fade magenta
    ;;
server-data)
    prompt fade red
    ;;
server-game)
    prompt fade cyan black
    ;;
lane-william)
    prompt fade yellow black grey
    ;;
*)
    case "$USER" in
        ubuntu|vagrant)
            prompt fade green black
            ;;
        *)
            prompt fade black grey white
            ;;
    esac
    ;;
esac

# NOTE: this fixes the issue commands that don't output a trailing newline (ie. cat files missing them) gets overridden by the prompt
unsetopt prompt_cr

# pyenv
. source-if-exists "${PYENV_ROOT}/completions/pyenv.zsh"

# kubectl
if command-exists kubectl; then
    source <(kubectl completion zsh)
fi

# misc
'??'() {
    if command-exists bat; then
        bat "$(command which "$@")"
    else
        cat "$(command which "$@")"
    fi
}

# DEBUGGING PERFORMANCE
# zprof
