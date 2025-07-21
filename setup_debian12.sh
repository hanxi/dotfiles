#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error.
# Print each command before executing it.
set -euo pipefail
set -x

# URLs and Versions
DELTA_VERSION="0.17.0"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

#######################################################################
# Pre-install system dependencies
#######################################################################
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    gcc make g++ tmux bison bash-completion subversion \
    tig unzip cmake luarocks ripgrep wget curl git

#######################################################################
# Install Mise (Version Manager)
#######################################################################
echo "Installing or updating mise..."
#curl https://mise.run | sh

echo "Configuring mise shell integration..."
MISE_ACTIVATE_LINE='eval "$(~/.local/bin/mise activate bash)"'
if ! grep -qF "$MISE_ACTIVATE_LINE" "$HOME/.bashrc"; then
    echo "Adding mise activation to .bashrc..."
    echo -e "\n# Activate mise for shell integration\n$MISE_ACTIVATE_LINE" >> "$HOME/.bashrc"
else
    echo "mise activation is already configured in .bashrc."
fi

source "$HOME/.bashrc"

#######################################################################
# Install tools using Mise
#    Mise automatically handles architecture and versions.
#######################################################################
# 'use --global' is like 'install', making the tool available everywhere.
# Using '@latest' ensures you always get the newest version.
# You could also pin a version, e.g., 'delta@0.17.0'

mise use --global delta@latest
mise use --global node@lts
mise use --global neovim@stable
mise use --global python@3.12
mise use --global go@1.24.5

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

echo "-----------------------------------------------------------"
echo "Finished installing Neovim, mise, and other dependencies!"
echo "IMPORTANT: Please run 'source ~/.bashrc' or restart your terminal to use the 'nvim' and 'mise' commands."
echo "-----------------------------------------------------------"

