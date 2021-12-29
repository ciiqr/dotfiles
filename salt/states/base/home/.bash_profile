[[ -f ~/.shared_profile ]] && . ~/.shared_profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

. source-if-exists "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
