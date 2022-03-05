if [[ -z "$PS1" ]]; then
    return
fi

. source-if-exists ~/.shared_rc

# completions
. source-first-found \
    "${HOMEBREW_PREFIX}/etc/bash_completion"

# - google cloud
. source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

# Key Bindings

# NOTE: run `bind -p` to see all keybindings
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'
bind '"\e[3;5~":kill-word'

# Prompt
prompt_fade()
{
    declare primary_colour_name="$1"
    declare text_colour_name="${2:-white}"
    declare date_colour_name="${3:-white}"

    if [[ -z "$primary_colour_name" ]]; then
        echo 'usage: prompt_fade <primary-colour> [<text-colour>] [<date-colour>]'
        return 1
    fi

    declare -A colour_names_to_code=(
        [black]=0
        [red]=1
        [green]=2
        [yellow]=3
        [blue]=4
        [magenta]=5
        [cyan]=6
        [white]=7
    )

    declare primary_colour="${colour_names_to_code[$primary_colour_name]}"
    if [[ -z "$primary_colour" ]]; then
        echo 'invalid primary colour:' "$primary_colour_name"
        return 1
    fi

    declare text_colour="${colour_names_to_code[$text_colour_name]}"
    if [[ -z "$text_colour" ]]; then
        echo 'invalid text colour:' "$text_colour_name"
        return 1
    fi

    declare date_colour="${colour_names_to_code[$date_colour_name]}"
    if [[ -z "$date_colour" ]]; then
        echo 'invalid date colour:' "$date_colour_name"
        return 1
    fi

    # escaped colours
    declare primary_fg="\[$(tput setaf "$primary_colour")\]"
    declare primary_bg="\[$(tput setab "$primary_colour")\]"
    declare text_fg="\[$(tput setaf "$text_colour")\]"
    declare date_fg="\[$(tput setaf "$date_colour")\]"
    declare date_bg="\[$(tput setab "${colour_names_to_code[black]}")\]"
    declare reset="\[$(tput sgr0)\]"

    if [[ "$text_colour_name" == 'black' && "$TERM" == 'alacritty' ]]; then
        # disable bold if black on alacritty because we use bright for bold text
        declare bold=''
    else
        declare bold="\[$(tput bold)\]"
    fi

    # build prompt
    declare prompt=''
    # - fade in
    prompt+="${primary_bg}${bold}${primary_fg}█▓▒░"
    # - user@hostname
    prompt+="${text_fg}\u@\h${reset}"
    # - fade out
    prompt+="${date_bg}${primary_fg}█▓▒░"
    # - date time
    prompt+="${date_fg}${bold} \[""\D{%a %b %d %I:%M:%S%P}""\] \n"
    # - pwd
    prompt+="${primary_fg}\w/${reset} "

    # set prompt
    PS1="$prompt"
}

case "$DOTFILES_HOSTNAME" in
desktop-william|laptop-william)
    prompt_fade magenta
    ;;
server-data)
    prompt_fade red
    ;;
lane-william)
    prompt_fade yellow black
    ;;
*)
    case "$USER" in
        ubuntu|vagrant)
            prompt_fade green black
            ;;
        *)
            prompt_fade white black
            ;;
    esac
    ;;
esac

# History
HISTSIZE=101000
HISTFILESIZE=100000
shopt -s histappend

# Misc
shopt -s checkwinsize
shopt -s autocd
shopt -s extglob

# nvm
. source-if-exists "$NVM_DIR/bash_completion"

# pyenv
. source-if-exists "${PYENV_ROOT}/completions/pyenv.bash"

# kubectl
if command-exists kubectl; then
    source <(kubectl completion bash)
fi

# misc
?? () { cat "$(which "$@")"; }
