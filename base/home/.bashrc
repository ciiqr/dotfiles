
[ -z "$PS1" ] && return

. source-if-exists ~/.shared_rc

# Keybindings

# - Use ctl keys to move forward and back in words (http://stackoverflow.com/questions/5029118/bash-ctrl-to-move-cursor-between-words-strings)
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'
# bind '"\e[3;5~":kill-word'


# Setup hooks
if type precmd >/dev/null 2>&1; then
    PROMPT_COMMAND='precmd'
fi

if type preexec >/dev/null 2>&1; then
    preexec_invoke_exec() {
        [ -n "$COMP_LINE" ] && return  # do nothing if completing
        [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
        local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
        preexec "$this_command"
    }
    trap 'preexec_invoke_exec' DEBUG
fi

# Prompt
ps-escape()
{
    echo "\[""$1""\]"
}

ps-colour()
{
    echo `ps-escape "\e\e[""$1""m"`
}

PS_FG_BLACK="\[\e\e"`tput setaf 0`"\]"
PS_FG_RED="\[\e\e"`tput setaf 1`"\]"
PS_FG_GREEN="\[\e\e"`tput setaf 2`"\]"
PS_FG_YELLOW="\[\e\e"`tput setaf 3`"\]"
# TODO: 
# PS_FG_YELLOW=`ps-colour 92`
PS_FG_BLUE="\[\e\e"`tput setaf 4`"\]"
PS_FG_MAGENTA="\[\e\e"`tput setaf 5`"\]"
PS_FG_CYAN="\[\e\e"`tput setaf 6`"\]"
PS_FG_WHITE="\[\e\e"`tput setaf 7`"\]"

PS_BG_BLACK="\[\e\e"`tput setab 0`"\]"
PS_BG_RED="\[\e\e"`tput setab 1`"\]"
PS_BG_GREEN="\[\e\e"`tput setab 2`"\]"
PS_BG_YELLOW="\[\e\e"`tput setab 3`"\]"
PS_BG_BLUE="\[\e\e"`tput setab 4`"\]"
PS_BG_MAGENTA="\[\e\e"`tput setab 5`"\]"
PS_BG_CYAN="\[\e\e"`tput setab 6`"\]"
PS_BG_WHITE="\[\e\e"`tput setab 7`"\]"

PS_RESET="\[\e\e"`tput sgr0`"\]"
PS_BOLD="\[\e\e"`tput bold`"\]"
# PS_BOLD=`ps-colour 1`

# Defaults

PS_USER="\u"
PS_USER_HOST_SEP="@"
PS_HOST="\h"
PS_DATE="\[""\D{%a %b %d %I:%M:%S%P}""\]"

# Customize Prompt
# TODO: Move these out of here
case `hostname` in
desktop|laptop)
    PS_FG_COLOUR="$PS_FG_BLUE"
    PS_BG_COLOUR="$PS_BG_BLUE"
    PS_WHOHOST_TEXT_COLOURS="$PS_BG_BLUE$PS_FG_WHITE"
    ;;
server-data)
    PS_FG_COLOUR="$PS_FG_RED"
    PS_BG_COLOUR="$PS_BG_RED"
    PS_WHOHOST_TEXT_COLOURS="$PS_BG_RED$PS_FG_WHITE"
    ;;
server-web)
    PS_FG_COLOUR="$PS_FG_RED"
    PS_BG_COLOUR="$PS_BG_RED"
    PS_WHOHOST_TEXT_COLOURS="$PS_BG_MAGENTA$PS_FG_WHITE"
    ;;
Checkouts-MacBook-Pro*)
    PS_USER=""
    PS_USER_HOST_SEP=""
    PS_HOST="macbook"
    PS_FG_COLOUR="$PS_BOLD$PS_FG_YELLOW"
    PS_BG_COLOUR="$PS_BG_YELLOW"
    # PS_WHOHOST_TEXT_COLOURS="${PS_BOLD}${PS_BG_YELLOW}${PS_FG_BLACK}"
    PS_WHOHOST_TEXT_COLOURS=`ps-colour 103``ps-colour 30`
    ;;
*)
    case "$USER" in
        vagrant)
            PS_FG_COLOUR="$PS_FG_GREEN"
            PS_BG_COLOUR="$PS_BG_GREEN"
            PS_WHOHOST_TEXT_COLOURS="$PS_FG_BLACK"
            ;;
        *)
	    PS_FG_COLOUR="$PS_FG_WHITE"
	    PS_BG_COLOUR="$PS_BG_WHITE"
	    PS_WHOHOST_TEXT_COLOURS="$PS_BG_BLACK$PS_FG_WHITE"
            ;;
    esac
    ;;
esac

# TODO: http://unix.stackexchange.com/questions/31695/how-to-make-the-terminal-display-usermachine-in-bold-letters
# TODO: http://misc.flogisoft.com/bash/tip_colors_and_formatting
# TODO: Change to this for side bits: for i in {16..21} {21..16} ; do echo -en "\e[48;5;${i}m \e[0m" ; done ; echo

# Path on second line
export PS1="${PS_FG_COLOUR}${PS_BOLD}${PS_BG_COLOUR}█▓▒░${PS_FG_WHITE}${PS_BG_COLOUR}${PS_BOLD}${PS_WHOHOST_TEXT_COLOURS}${PS_USER}${PS_USER_HOST_SEP}${PS_HOST}${PS_RESET}${PS_FG_COLOUR}${PS_BG_BLACK}█▓▒░${PS_FG_WHITE}${PS_BG_BLACK}${PS_BOLD} ${PS_DATE} \n${PS_FG_COLOUR}${PS_BG_BLACK}${PS_BOLD}\w/${PS_RESET} "

# 
HISTSIZE=101000
HISTFILESIZE=100000
shopt -s histappend

shopt -s checkwinsize
shopt -s autocd

. source-all-from ~/.bashrc.d
