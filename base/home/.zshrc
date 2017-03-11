#!/usr/bin/env zsh

. source-if-exists ~/.shared_rc

# TODO: Move generic stuff to shared, and move out environment and whatever specific stuff to their own files as well....

# TODO: https://wiki.archlinux.org/index.php/Home_and_End_keys_not_working#TERM



### Set Oh My Zsh options ###
#############################

# Set the key mapping style to 'emacs' or 'vi'
zstyle ':omz:editor' keymap 'emacs'
# Auto convert .... to ../..
zstyle ':omz:editor' dot-expansion 'no'
# Set case-sensitivity for completion, history lookup, etc
zstyle ':omz:*:*' case-sensitive 'no'
# Color output
zstyle ':omz:*:*' color 'yes'
# Auto set the tab and window titles
zstyle ':omz:terminal' auto-title 'yes'
# Set the plugins to load (see $OMZ/plugins/)
zstyle ':omz:load' plugin 'archive' 'git'
# Set the prompt theme to load. options ('random')
zstyle ':omz:prompt' theme 'sorin'

# This will make you shout: OH MY ZSHELL!
. source-if-exists "$HOME/.oh-my-zsh/init.zsh"

# Plugins
# Syntax Highlighting
. source-if-exists /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### My Config ###
#################

# TODO: Maybe configure
# select-word-style

# ZSH
HISTFILE=~/.histfile
HISTSIZE=101000
SAVEHIST=100000
LISTMAX=0 # zsh: do you wish to see all NNN possibilities (NNN lines)?" downward (default is 100). Only ask before displaying completions if doing so would scroll.
zstyle :compinstall filename "$HOME/.zshrc"

# WAV-Configured

# TODO: Compile as applicable
# autoload -Uz zrecompile
# autoload zrecompile
# zrecompile "$ZDOTDIR" "$ZDOTDIR/functions"

autoload -Uz compinit promptinit
#Complete
compinit
# Use Bash completions also...
autoload bashcompinit
bashcompinit
#Prompt
promptinit

# Glob's without any matches are sent to the command as is
unsetopt no_match

# Change directory directly
setopt auto_cd

# Make cd push the old directory onto the directory stack.
setopt auto_push_d

# Ignore duplicate directories
setopt push_d_ignore_dups

#History-No-Dups
setopt hist_ignore_dups

# Append history to file right away
setopt inc_append_history

# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list
setopt hist_expire_dups_first

# Remove superfluous blanks from each command line being added to the history list.
setopt hist_reduce_blanks

# Allow comments
setopt interactive_comments

# Make the completion list smaller (print the matches in columns with different widths)
setopt list_packed

# zsh: sure you want to delete all the files in /etc [yn]?
setopt no_rm_star_silent

# Print non-zero exit values
setopt print_exit_value

# auto-complete aliases
setopt completealiases

# Disable printing of ^C and related control commands
stty -ctlecho


# Named directories
# NOTE: See all/default
# hash -d screen-shots=~/Random/Screens/


# automatically remove duplicates from these arrays
typeset -gU path cdpath manpath fpath

#Command-Not-Found
#[ -r /etc/profile.d/cnf.sh ] && . /etc/profile.d/cnf.sh

# List Path Items
lspath () {
	(($#)) || set ''
	print -lr -- $^path/*$^@*(N:t) | sort -u
}

# Character which are part of a word
export WORDCHARS=_-\|

# XTerm 
function xterm_set_tabs() {
	TERM=linux
	export $TERM
	setterm -regtabs 4
	TERM=xterm
	export $TERM
}

# XTerm Window Name & print tab's as 4 spaces (instead of default 8)
case $TERM in                   
	xterm*)
		# TODO: I'm not totally pleased with these, but I guess they're fine for now...
		precmd()
		{
			print -Pn "\e]2;%~ - %n@%m\a" 2>/dev/null
		}
		preexec()
		{
			print -Pn "\e]2;$1 - %n@%m\a" 2>/dev/null
		}
		xterm_set_tabs
		;;
esac

# Prompt
# fade
# - text background date
# prompt walters
# prompt fade black grey blue
# prompt fade green
# prompt fade magenta
# prompt fade yellow
# TODO: Move this to be a dotfiles/{HOSTNAME}/home/.zsh_prompt file which we sourced here. But also have to have a default in /home
# TODO: Consider more advanced prompt configuration, and other things from here: http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt
# I might be able to make it just automatically hide the username section when it's the default and override the hostname, see: https://gist.github.com/logicmd/4015090
# https://sourceforge.net/p/zsh/code/ci/master/tree/Functions/Prompts/prompt_fade_setup & also look at agnoster theme which does some of the things I want
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# http://unix.stackexchange.com/questions/238358/how-can-i-make-my-zsh-theme-fade-look-good-in-urxvt
case `hostname` in
desktop|laptop)
	prompt fade blue
	;;
server-data)
	prompt fade red
	;;
server-web)
	prompt fire red magenta blue white white white
	;;
Checkouts-MacBook-Pro*)
	prompt fade yellow grey grey
	;;
*)
	prompt fade black grey white
	;;
esac



# Key Bindings
# TODO: https://superuser.com/questions/197813/cycle-through-matches-in-zsh-history-incremental-pattern-search-backward
# TODO: I continue to hate the state of keybindings

bindkey -e
distro="`lsb_release -i -s`"
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
			arch)
				bindkey  "\e[H"     beginning-of-line
				bindkey  "\e[F"      end-of-line

				bindkey '\e[1;5C' forward-word
				bindkey '\e[1;5D' backward-word
				
				
				bindkey '^?' backward-kill-word
				bindkey '\e[3;5~' kill-word
				
				bindkey '\e[3~' delete-char
				;;
			*)
				echo "~/.zshrc: Unknown distro: '$distro'"
				;;
		esac
		;;

	*)
		# bindkey  "\e[H"     beginning-of-line
		# bindkey  "\e[F"      end-of-line

		# bindkey '\e[C' forward-word
		# bindkey '\e[D' backward-word
		
		bindkey '^H' backward-kill-word
		# bindkey '\e[3~' kill-word
		;;
esac

# TODO: Would be nice, but there are some issues like keybindings
# screen -DRA
