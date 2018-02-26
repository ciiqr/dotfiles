#!/usr/bin/env bash

# Make directories
make_directory ssh_backup "$home_backup/.ssh"

if [[ ${priv_conf[@]+isset} ]]; then
	# Transfer private ssh configs
	transfer "${priv_conf[ssh_configs]}" "$destination/.ssh" "$ssh_backup"

	# Fix permissions of keys
	$DEBUG chmod 0600 "$destination/.ssh/keys/"*
fi
