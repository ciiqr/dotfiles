#!/usr/bin/env bash

_colour_fg_black="$(tput setaf 0)"
_colour_fg_red="$(tput setaf 1)"
_colour_fg_green="$(tput setaf 2)"
_colour_fg_yellow="$(tput setaf 3)"
_colour_fg_blue="$(tput setaf 4)"
_colour_fg_magenta="$(tput setaf 5)"
_colour_fg_cyan="$(tput setaf 6)"
_colour_fg_white="$(tput setaf 7)"

_colour_bg_black="$(tput setab 0)"
_colour_bg_red="$(tput setab 1)"
_colour_bg_green="$(tput setab 2)"
_colour_bg_yellow="$(tput setab 3)"
_colour_bg_blue="$(tput setab 4)"
_colour_bg_magenta="$(tput setab 5)"
_colour_bg_cyan="$(tput setab 6)"
_colour_bg_white="$(tput setab 7)"

_colour_reset="$(tput sgr0)"
_colour_bold="$(tput bold)"

colour::fg::black() { echo -n "$_colour_fg_black"; }
colour::fg::red() { echo -n "$_colour_fg_red"; }
colour::fg::green() { echo -n "$_colour_fg_green"; }
colour::fg::yellow() { echo -n "$_colour_fg_yellow"; }
colour::fg::blue() { echo -n "$_colour_fg_blue"; }
colour::fg::magenta() { echo -n "$_colour_fg_magenta"; }
colour::fg::cyan() { echo -n "$_colour_fg_cyan"; }
colour::fg::white() { echo -n "$_colour_fg_white"; }

colour::bg::black() { echo -n "$_colour_bg_black"; }
colour::bg::red() { echo -n "$_colour_bg_red"; }
colour::bg::green() { echo -n "$_colour_bg_green"; }
colour::bg::yellow() { echo -n "$_colour_bg_yellow"; }
colour::bg::blue() { echo -n "$_colour_bg_blue"; }
colour::bg::magenta() { echo -n "$_colour_bg_magenta"; }
colour::bg::cyan() { echo -n "$_colour_bg_cyan"; }
colour::bg::white() { echo -n "$_colour_bg_white"; }

colour::reset() { echo -n "$_colour_reset"; }
colour::bold() { echo -n "$_colour_bold"; }
