#!/usr/bin/env sh

if [ -n "$ZSH_VERSION" ]; then
    # TODO: Only if exists, and maybe also the global files...
    # . "/etc/zsh/zprofile"
    [ -f "$HOME/.zprofile" ] && . "$HOME/.zprofile"
elif [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"
else
    echo "What are you even using?"
fi
