#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error.
# Print each command before executing it.
set -euo pipefail
set -x

mise use --global delta@latest
mise use --global node@lts
mise use --global neovim@stable
mise use --global python@3.12
mise use --global go@1.24.5
mise use --global fzf

