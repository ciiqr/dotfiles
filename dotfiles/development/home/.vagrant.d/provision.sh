#!/usr/bin/env bash

# TODO: Add support for more than just debian
# TODO: Figure out if we can prevent this running in a windows guest

# Prevent running if not debian
if ! `type apt-get >/dev/null 2>&1`; then
	echo "not supported on the current platform"
	exit 0
fi

# Silence apt
quiet_apt_get()
{
	export DEBIAN_FRONTEND=noninteractive
	apt-get -qq -y "$@" >/dev/null
}

apt_wait()
{
	i=0
	while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
		if ((i % 10 == 0)); then
			echo "waiting for apt lock to release: ${i}s"
		fi
		sleep 1;
		((i++))
	done
}

vagrant_user()
{
	# Find the first of these users that exists
	for user in vagrant ubuntu root; do
		if grep -q '^'"$user"':' /etc/passwd; then
			echo "$user"
			break
		fi
	done
}

# user
declare user=`vagrant_user`
if [[ -z "$user" ]]; then
	echo "couldn't find user"
	exit 0
fi

# Obviously only works on debian based systems
apt_wait
quiet_apt_get install git
quiet_apt_get install zsh

# Switch to zsh
chsh -s /usr/bin/zsh "$user"

# Make sure zsh works properly... sigh ubuntu
echo "emulate sh -c 'source /etc/profile'" > /etc/zsh/zprofile

su "$user" <<EOF
	# Make sure we have dotfiles
	[[ ! -d ~/.dotfiles ]] && exit 0

	cd ~/.dotfiles/
	if [[ -d ~/.private-config ]]; then
		install_opts='--private-config ~/.private-config'
	fi

	./install.sh -q --categories 'personal development' $install_opts
EOF
