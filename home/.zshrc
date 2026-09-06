#!/usr/bin/env zsh

# DEBUGGING PERFORMANCE
# zmodload zsh/zprof

# automatically remove duplicates from these arrays
typeset -gU path cdpath manpath fpath precmd_functions

# Load
autoload -Uz compinit bashcompinit promptinit

# mise
if type 'mise' > /dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# omz
plugins=(z)
DISABLE_AUTO_UPDATE="true"
ZSH_DISABLE_COMPFIX="true"
zstyle ':omz:lib:directories' aliases no # disable aliases for quick navigation (1, 2, 3, etc)
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

# Completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=(
        "${HOMEBREW_PREFIX}/share/zsh-completions"
        "${HOMEBREW_PREFIX}/share/zsh/site-functions"
        "${fpath[@]}"
    )
fi

fpath=("$HOME/.zcompletions" "${fpath[@]}")

# complete .files
zstyle ':completion:*' file-patterns '%p(D):globbed-files *(D-/):directories' '*(D):all-files'
# colors for file/dir completions
zstyle ':completion:*' list-colors "$LS_COLORS"
compinit -u
bashcompinit

# Shell Options
unsetopt no_match # Glob's without any matches are sent to the command as is
setopt interactive_comments
# - chdir
setopt auto_cd
setopt auto_push_d
setopt push_d_ignore_dups
# - history
setopt hist_ignore_dups
setopt inc_append_history # append to history immediately after running
setopt hist_expire_dups_first
setopt hist_reduce_blanks
setopt extended_history  # record timestamp of command in HISTFILE
setopt hist_ignore_space # ignore commands that start with space
setopt hist_verify       # show command with history expansion to user before running it
setopt share_history     # share command history data between all open shells
# - completions
setopt list_packed         # Make the completion list smaller by printing the matches in columns with different widths
setopt no_complete_aliases # NOTE: despite the name, this actually enables aliases to be auto-completed as though it were the full command.
# - errors
setopt no_rm_star_silent
setopt print_exit_value

# Disable printing of ^C and related control commands
stty -ctlecho

HISTFILE="${HOME}/.histfile"
HISTSIZE=101000
SAVEHIST=100000
LISTMAX=0 # only show the following prompt if doing so would scroll 'do you wish to see all NNN possibilities?'
export WORDCHARS='_-|'

# Precmd
_dotfiles_precmd() {
    # NOTE: not sure why the tab size resets 🤷
    tabs -4
}
precmd_functions+=(_dotfiles_precmd)

# Key Bindings
# NOTE: run `bindkey` to see all keybindings
bindkey -e # emacs
# NOTE:
# - get keybinding codes with: $ showkey -a
# - print terminfo with: $ infocmp -1
if [[ "$OSTYPE" == darwin* && "$TERM_PROGRAM" == 'Apple_Terminal' ]]; then
    bindkey '\e^[OA' beginning-of-line # alt + up
    bindkey '\e^[OB' end-of-line       # alt + down
    bindkey '\e(' kill-word            # alt + delete
else
    # alacritty/kitty/foot/ghostty/wezterm at least all seem to work the same
    bindkey '^[[1;3A' beginning-of-line # alt + up
    bindkey '^[[1;3B' end-of-line       # alt + down
    bindkey '^[[1;3C' forward-word      # alt + right
    bindkey '^[[1;3D' backward-word     # alt + left
    bindkey '^[[3;5~' kill-word         # ctrl + delete
    bindkey '^H' backward-kill-word     # ctrl + backspace
fi

# Prompt
promptinit
# - prompt fade <background> <text> <date>
case "$DOTFILES_MACHINE" in
    laptop-william)
        prompt fade magenta
        ;;
    desktop-william)
        prompt fade red
        ;;
    *-william)
        prompt fade yellow black grey
        ;;
    *)
        prompt fade grey
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
