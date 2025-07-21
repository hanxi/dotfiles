#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error.
# Print each command before executing it.
set -euo pipefail
set -x

NVIM_CONFIG_DIR="$HOME/.config/nvim"

#######################################################################
# Setup Nvim Config
#######################################################################
echo "Setting up Neovim configuration..."
if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    echo "Existing config found. Pulling latest changes."
    cd "$NVIM_CONFIG_DIR"
    git pull
else
    echo "Cloning new config repository."
    git clone --depth=1 https://github.com/hanxi/nvim-config.git "$NVIM_CONFIG_DIR"
fi

