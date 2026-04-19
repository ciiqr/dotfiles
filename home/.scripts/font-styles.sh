#!/usr/bin/env bash

set -e

declare text="${1:-Hello World}"
printf "Regular     : %s\n" "$text"
printf "Bold        : \033[1m%s\033[0m\n" "$text"
printf "Italic      : \033[3m%s\033[0m\n" "$text"
printf "Bold Italic : \033[1m\033[3m%s\033[0m\n" "$text"
