#!/usr/bin/env bash

case "$HOST_OS" in
	osx)
		sublime_path="$destination/Library/Application Support/Sublime Text 3"
		;;
	linux)
		sublime_path="$destination/.config/sublime-text-3"
		;;
	windows)
		sublime_path="$destination/AppData/Roaming/Sublime Text 3"
		;;
	*)
		echo $0: Unrecognized os $HOST_OS, we do not know where to put sublime configs...
		exit 1
		;;
esac

# Make directories
$DEBUG mkdir -p "$sublime_path"/{Installed\ Packages,Packages/User}
make_directory sublime_backup "$backup/$category"

# Download Package Control
download_to "http://packagecontrol.io/Package%20Control.sublime-package" "$sublime_path/Installed Packages/Package Control.sublime-package"

# Create temp dir
sublime_temp_dir="$temp_dir/$category"
$DEBUG mkdir -p "$sublime_temp_dir"

declare -a packages
packages=(
	'Package Control'

	'Theme - SoDaReloaded'

	'MoveTab'
	'SideBarEnhancements'

	'Case Conversion'
	'SortBy'
	'TrailingSpaces'
	'Normalize Indentation'

	'Delete Current File'
	'Quick File Move'
	'Terminal'
	'Superlime'

	'Fold Comments'

	'ApacheConf.tmLanguage'
	'Handlebars'
	'INI'
	'Smarty'
	'C++11'
	'Hjson'
	'HOCON Syntax Highlighting'
	'IDL-Syntax'
	'plist'
	'Sass'
	'SCSS'
	'Swift'

	'PHPUnit Completions'
	'Statusbar Path'
	'SublimeTmpl'
)

declare -a repositories
repositories=(
	# 'https://github.com/n1k0/SublimeHighlight/tree/python3'
)

# TODO: 'Project Specific Syntax Settings' and make machines files default to a reasonable syntax for each...
	# https://github.com/reywood/sublime-project-specific-syntax

# TODO: Go through packages I've previously had installed...
# CSS Colors
# FuzzyFileNav
# FuzzyFilePath
# PackageResourceViewer
# PHPIntel
# RawLineEdit
# WhoCalled Function Finder
# All Autocomplete
# BeautifyRuby
# Better CoffeeScript
# Bison
# BufferScroll
# C++ Snippets
# ClangAutoComplete
# CMakeEditor
# CMakeSnippets
# CoffeeComplete Plus (Autocompletion)
# Color Highlighter
# CSS Format
# Default File Type
# Dotfiles Syntax Highlighting
# Gist
# Gradle_Language
# HexViewer
# Highlight
# HTML-CSS-JS Prettify
# HTMLBeautify
# Javascript Beautify
# JavaScript Snippets
# Jinja2
# NimLime
# Number King
# Package Syncing
# PackageDev
# PKGBUILD
# Plist Binary
# Processing
# Project Port
# Python Breakpoints
# QMakeProject
# SASS Build
# SCSS Snippets

# SublimeAStyleFormatter
# SublimeCodeIntel
# SublimeGDB
# SublimeHighlight

# SublimeOnSaveBuild
# SwiftKitten
# SyntaxFold
# Text Pastry
# URLEncode
# W3CValidators
# WordCount
# EJS
# ShowEncoding
# EncodingHelper
# JSX

# # Probably not...
# LiveStyle

# # Only if I end up needing
# SublimeLinter-coffee
# SublimeLinter-contrib-clang
# SublimeLinter-html-tidy
# SublimeLinter-jsl
# SublimeLinter-lua
# SublimeLinter-php
# SublimeLinter-pylint

# # These were disabled anyways, so we almost certainly don't need them
# ActionScript
# AppleScript
# ASP
# Batch File
# BeautifyRuby
# CTags
# HexViewer
# IDL-Syntax
# Javascript Beautify
# Number King
# Processing
# Project Port
# SublimeAStyleFormatter
# SublimeCodeIntel
# SublimeGDB
# SublimeOnSaveBuild

user_config_dir="config"
user_config_gen_dir="config.gen"

# Generate Package Control config
packages_json_string="`json_string_array "${packages[@]}" | escape_for_sed`"
repositories_json_string="`json_string_array "${repositories[@]}" | escape_for_sed`"

if [[ -z "$DEBUG" ]]; then
	sed 's/REPLACE_PACKAGES/'"$packages_json_string"'/;s/REPLACE_REPOSITORIES/'"$repositories_json_string"'/' "$script_directory/$category/$user_config_gen_dir/Package Control.sublime-settings" > "$sublime_temp_dir/Package Control.sublime-settings"
else
	$DEBUG sed 's/REPLACE_PACKAGES/'"$packages_json_string"'/;s/REPLACE_REPOSITORIES/'"$repositories_json_string"'/' "$script_directory/$category/$user_config_gen_dir/Package Control.sublime-settings" \> "$sublime_temp_dir/Package Control.sublime-settings"
fi

# Generate Preferences config
if contains_option hidpi "${categories[@]}"; then
	DPI_SCALE=2
else
	DPI_SCALE=1
fi

if [[ -z "$DEBUG" ]]; then
	sed 's/REPLACE_DPI_SCALE/'"$DPI_SCALE"'/' "$script_directory/$category/$user_config_gen_dir/Preferences.sublime-settings" > "$sublime_temp_dir/Preferences.sublime-settings"
else
	$DEBUG sed 's/REPLACE_DPI_SCALE/'"$DPI_SCALE"'/' "$script_directory/$category/$user_config_gen_dir/Preferences.sublime-settings" \> "$sublime_temp_dir/Preferences.sublime-settings"
fi

# Transfer all configs
transfer "$sublime_temp_dir" "$sublime_path/Packages/User" "$sublime_backup"
transfer "$script_directory/$category/$user_config_dir" "$sublime_path/Packages/User" "$sublime_backup"

# Create symlink
case "$HOST_OS" in
	osx)
		$DEBUG ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/.local/bin/subl3
		;;
esac
