#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# TODO: consider pulling this stuff into my config proper
. source-if-exists ~/.oh-my-zsh/lib/key-bindings.zsh
. source-if-exists ~/.oh-my-zsh/lib/functions.zsh
. source-if-exists ~/.oh-my-zsh/lib/termsupport.zsh

. source-if-exists ~/.shared_rc

# syntax-highlighting
. source-first-found \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggestions
. source-first-found \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

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
export WORDCHARS='_-|'

# nvm
. source-if-exists "$NVM_DIR/bash_completion"

# pyenv
. source-if-exists "${PYENV_ROOT}/completions/pyenv.zsh"

# kubectl
if command-exists kubectl; then
    source <(kubectl completion zsh)
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
lane-william)
    prompt fade yellow black grey
    ;;
*)
    case "$USER" in
        ubuntu)
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


# Key Bindings
# TODO: https://superuser.com/questions/197813/cycle-through-matches-in-zsh-history-incremental-pattern-search-backward
# TODO: I continue to hate the state of keybindings

# NOTE: run `bindkey` to see all keybindings

bindkey -e
if [[ "$OSTYPE" == darwin* ]]; then
    # TODO: Consider getting osx version with `sw_vers -productName && sw_vers -productVersion` or maybe just get os if no distro...
    distro="macos"
elif command-exists lsb_release; then
    distro="$(lsb_release -i -s)"
fi
distro="$distro:l"

case "$TERM" in
    xterm*)

        case "$distro" in
            ubuntu)
                bindkey '\e[1;5C' forward-word
                bindkey '\e[1;5D' backward-word

                bindkey '^H' backward-kill-word
                bindkey '\e[3;5~' kill-word
                ;;
            # TODO: only if I end up needing... not sure the few things here that are default aren't working regardless...
            # arch)
            #     bindkey  "\e[H"     beginning-of-line
            #     bindkey  "\e[F"      end-of-line

            #     bindkey '\e[1;5C' forward-word
            #     bindkey '\e[1;5D' backward-word

            #     bindkey '^?' backward-kill-word
            #     bindkey '\e[3;5~' kill-word

            #     bindkey '\e[3~' delete-char
            #     ;;
            macos)
                bindkey '\e^[OA' beginning-of-line # alt + up
                bindkey '\e^[OB' end-of-line       # alt + down
                bindkey '\e('    kill-word         # alt + delete
                ;;
        esac
        ;;
    *)
        bindkey '^H' backward-kill-word
        ;;
esac

. source-if-exists "${HOME}/.zshrc.d/${DOTFILES_PLATFORM}"
. source-if-exists "${HOME}/.zshrc.d/${DOTFILES_HOSTNAME}"


# DEBUGGING PERFORMANCE
# zprof
