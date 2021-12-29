#!/usr/bin/env zsh

[[ -f ~/.shared_profile ]] && . ~/.shared_profile

. source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
