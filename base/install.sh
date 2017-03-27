#!/usr/bin/env bash

base_omz_path="$destination/.oh-my-zsh"

# Download OMZ
if [[ ! -d "$base_omz_path" ]]; then
	$DEBUG quiet git clone git://github.com/robbyrussell/oh-my-zsh.git "$base_omz_path"
fi

$DEBUG quiet pushd "$base_omz_path"
	# Update OMZ
	$DEBUG quiet git pull
$DEBUG quiet popd
