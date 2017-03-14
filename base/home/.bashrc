
. source-if-exists ~/.shared_rc


# Keybindings

# - Use ctl keys to move forward and back in words (http://stackoverflow.com/questions/5029118/bash-ctrl-to-move-cursor-between-words-strings)
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'
# bind '"\e[3;5~":kill-word'



# Prompt

ps-escape()
{
    echo "\[""$1""\]"
}

ps-colour()
{
    echo `ps-escape "\e\033[""$1""m"`
}

PS_FG_BLACK="\[\e"`tput setaf 0`"\]"
PS_FG_RED="\[\e"`tput setaf 1`"\]"
PS_FG_GREEN="\[\e"`tput setaf 2`"\]"
PS_FG_YELLOW="\[\e"`tput setaf 3`"\]"
# TODO: 
# PS_FG_YELLOW=`ps-colour 92`
PS_FG_BLUE="\[\e"`tput setaf 4`"\]"
PS_FG_MAGENTA="\[\e"`tput setaf 5`"\]"
PS_FG_CYAN="\[\e"`tput setaf 6`"\]"
PS_FG_WHITE="\[\e"`tput setaf 7`"\]"

PS_BG_BLACK="\[\e"`tput setab 0`"\]"
PS_BG_RED="\[\e"`tput setab 1`"\]"
PS_BG_GREEN="\[\e"`tput setab 2`"\]"
PS_BG_YELLOW="\[\e"`tput setab 3`"\]"
PS_BG_BLUE="\[\e"`tput setab 4`"\]"
PS_BG_MAGENTA="\[\e"`tput setab 5`"\]"
PS_BG_CYAN="\[\e"`tput setab 6`"\]"
PS_BG_WHITE="\[\e"`tput setab 7`"\]"

PS_RESET="\["`tput sgr0`"\]"
PS_BOLD="\["`tput bold`"\]"
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
    PS_WHOHOST_TEXT_COLOURS="$PS_BOLD$PS_BG_BLUE$PS_FG_WHITE"
    ;;
server-data)
    PS_FG_COLOUR="$PS_FG_RED"
    PS_WHOHOST_TEXT_COLOURS="$PS_BOLD$PS_BG_RED$PS_FG_WHITE"
    ;;
server-web)
    PS_FG_COLOUR="$PS_FG_RED"
    PS_WHOHOST_TEXT_COLOURS="$PS_BOLD$PS_BG_MAGENTA$PS_FG_WHITE"
    ;;
Checkouts-MacBook-Pro*)
    PS_USER=""
    PS_USER_HOST_SEP=""
    PS_HOST="macbook"
    PS_FG_COLOUR="$PS_BOLD$PS_FG_YELLOW"
    # PS_WHOHOST_TEXT_COLOURS="${PS_BOLD}${PS_BG_YELLOW}${PS_FG_BLACK}"
    PS_WHOHOST_TEXT_COLOURS=`ps-colour 103``ps-colour 30`
    ;;
*)
    PS_FG_COLOUR="$PS_FG_WHITE"
    PS_WHOHOST_TEXT_COLOURS="$PS_BOLD$PS_BG_BLACK$PS_FG_WHITE"
    ;;
esac

# TODO: http://unix.stackexchange.com/questions/31695/how-to-make-the-terminal-display-usermachine-in-bold-letters
# TODO: http://misc.flogisoft.com/bash/tip_colors_and_formatting
# TODO: Change to this for side bits: for i in {16..21} {21..16} ; do echo -en "\e[48;5;${i}m \e[0m" ; done ; echo

# Path on second line
export PS1="${PS_FG_COLOUR}░▒▓█${PS_RESET}${PS_WHOHOST_TEXT_COLOURS}${PS_USER}${PS_USER_HOST_SEP}${PS_HOST}${PS_RESET}${PS_FG_COLOUR}█▓▒░${PS_RESET} ${PS_BOLD}${PS_DATE}${PS_RESET}\n${PS_FG_COLOUR}\w/${PS_RESET} "


# 
HISTSIZE=101000
HISTFILESIZE=100000
shopt -s histappend

shopt -s checkwinsize

. source-all-from ~/.bashrc.d
