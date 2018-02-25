#!/usr/bin/env bash

if [[ ${priv_conf[@]+isset} ]]; then
	# Transfer private configs
	transfer "${priv_conf[${category}_home]}" "$destination" "$home_backup"
fi
