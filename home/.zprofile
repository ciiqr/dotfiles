
# TODO: Need a way of determining if /etc/profile was sourced because Arch linux sources it in /etc/zsh/zprofile where as Ubuntu doesn't
# emulate sh -c 'source /etc/profile'

[[ -f ~/.shared_profile ]] && . ~/.shared_profile
