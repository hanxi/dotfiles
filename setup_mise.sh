#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error.
# Print each command before executing it.
set -euo pipefail
set -x

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
curl https://mise.run | sh

echo "Configuring mise shell integration..."
MISE_ACTIVATE_LINE='eval "$(~/.local/bin/mise activate bash)"'
if ! grep -qF "$MISE_ACTIVATE_LINE" "$HOME/.bashrc"; then
    echo "Adding mise activation to .bashrc..."
    echo -e "\n# Activate mise for shell integration\n$MISE_ACTIVATE_LINE" >> "$HOME/.bashrc"
else
    echo "mise activation is already configured in .bashrc."
fi

source "$HOME/.bashrc"

