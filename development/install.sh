#!/usr/bin/env bash

# Git
$DEBUG git config --global push.default simple
$DEBUG git config --global user.name "William Villeneuve"

$DEBUG git config --global alias.cm '!git commit -m'
$DEBUG git config --global alias.st status
$DEBUG git config --global alias.co checkout
$DEBUG git config --global alias.br branch

if contains_option frontend "${categories[@]}"; then
	$DEBUG git config --global diff.tool meld
	$DEBUG git config --global difftool.prompt false
fi

if [[ ${priv_conf[@]+isset} ]]; then
	$DEBUG git config --global user.email "${priv_conf[git_email]}"
fi
