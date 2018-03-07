#!/usr/bin/env sh

if [ -n "$ZSH_VERSION" ]; then
	# TODO: Only if exists, and maybe also the global files...
	# . "/etc/zsh/zprofile"
	. "$HOME/.zprofile"
elif [ -n "$BASH_VERSION" ]; then
	. "$HOME/.bash_profile"
else
	echo "What are you even using?"
fi
