#!/bin/bash
set -x

USE_CACHE=false
USE_CACHE=true

#######################################################################
# pre install
#######################################################################
sudo apt install -y gcc make g++ tmux bison bash-completion subversion \
    tig unzip cmake luarocks

#######################################################################
# install python3
#######################################################################

if [[ ! -d "$HOME/.local/packages/" ]]; then
    mkdir -p "$HOME/.local/packages/"
fi

if [[ ! -d "$HOME/.local/tools/" ]]; then
    mkdir -p "$HOME/.local/tools/"
fi

CONDA_DIR=$HOME/.local/tools/miniconda
CONDA_NAME=Miniconda.sh
CONDA_LINK="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh"

echo "Installing Python in user HOME"
echo "Downloading and installing miniconda"

if [[ "$USE_CACHE" = false || ! -f "$HOME/.local/packages/$CONDA_NAME" ]]; then
	curl -Lo "$HOME/.local/packages/$CONDA_NAME" $CONDA_LINK
fi

# Install conda silently
if [[ -d $CONDA_DIR ]]; then
	rm -rf "$CONDA_DIR"
fi
bash "$HOME/.local/packages/$CONDA_NAME" -b -p "$CONDA_DIR"

# Setting up environment variables
sed -i "\:"$CONDA_DIR/bin":d" "$HOME/.bashrc"
echo "export PATH=\"$CONDA_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"

echo "Installing Python packages"
declare -a py_packages=("pynvim" 'python-lsp-server[all]' "black" "vim-vint" "pyls-isort" "pylsp-mypy" "requests")

for p in "${py_packages[@]}"; do
	"$CONDA_DIR/bin/pip" install "$p"
done

#######################################################################
# Ripgrep part
#######################################################################
RIPGREP_DIR=$HOME/.local/tools/ripgrep
RIPGREP_SRC_NAME=$HOME/.local/packages/ripgrep.tar.gz
RIPGREP_LINK="https://github.com/BurntSushi/ripgrep/releases/download/12.0.0/ripgrep-12.0.0-x86_64-unknown-linux-musl.tar.gz"
if [[ -z "$(command -v rg)" ]] && [[ ! -f "$RIPGREP_DIR/rg" ]]; then
    echo "Install ripgrep"
    if [[ "$USE_CACHE" = false || ! -f $RIPGREP_SRC_NAME ]]; then
        echo "Downloading ripgrep and renaming"
        wget $RIPGREP_LINK -O "$RIPGREP_SRC_NAME"
    fi

    if [[ ! -d "$RIPGREP_DIR" ]]; then
        echo "Creating ripgrep directory under tools directory"
        mkdir -p "$RIPGREP_DIR"
        echo "Extracting to $HOME/.local/tools/ripgrep directory"
        tar zxvf "$RIPGREP_SRC_NAME" -C "$RIPGREP_DIR" --strip-components 1
    fi

    sed -i "\:"$RIPGREP_DIR":d" "$HOME/.bashrc"
    echo "export PATH=\"$RIPGREP_DIR:\$PATH\"" >> "$HOME/.bashrc"
else
    echo "ripgrep is already installed. Skip installing it."
fi

#######################################################################
# Ctags install
#######################################################################
CTAGS_SRC_DIR=$HOME/.local/packages/ctags
CTAGS_DIR=$HOME/.local/tools/ctags
CTAGS_LINK="https://github.com/universal-ctags/ctags.git"
if [[ "$USE_CACHE" = false || ! -f "$CTAGS_DIR/bin/ctags" ]]; then
    echo "Install ctags"

    if [[ ! -d $CTAGS_SRC_DIR ]]; then
        mkdir -p "$CTAGS_SRC_DIR"
    else
        # Prevent an incomplete download.
        rm -rf "$CTAGS_SRC_DIR"
    fi

    git clone --depth=1 "$CTAGS_LINK" "$CTAGS_SRC_DIR" && cd "$CTAGS_SRC_DIR"
    ./autogen.sh && ./configure --prefix="$CTAGS_DIR"
    make -j && make install

    sed -i "\:"$CTAGS_DIR/bin":d" "$HOME/.bashrc"
    echo "export PATH=\"$CTAGS_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
else
    echo "ctags is already installed. Skip installing it."
fi

#######################################################################
# Nvim install
#######################################################################
NVIM_DIR=$HOME/.local/tools/nvim
NVIM_SRC_NAME=$HOME/.local/packages/nvim-linux64.tar.gz
NVIM_CONFIG_DIR=$HOME/.config/nvim
NVIM_LINK="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
if [[ "$USE_CACHE" = false || ! -f "$NVIM_DIR/bin/nvim" ]]; then
    echo "Installing Nvim"
    echo "Creating nvim directory under tools directory"

    if [[ ! -d "$NVIM_DIR" ]]; then
        mkdir -p "$NVIM_DIR"
    fi

    if [[ "$USE_CACHE" = false || ! -f $NVIM_SRC_NAME ]]; then
        echo "Downloading Nvim"
        wget "$NVIM_LINK" -O "$NVIM_SRC_NAME"
    fi
    echo "Extracting neovim"
    tar zxvf "$NVIM_SRC_NAME" --strip-components 1 -C "$NVIM_DIR"

    sed -i "\:"$NVIM_DIR/bin":d" "$HOME/.bashrc"
    echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
else
    echo "Nvim is already installed. Skip installing it."
fi

# install delta
musl=$([[ $(lsb_release -r | cut -f2) == "20.04" ]] && echo "" || echo "-musl") # https://github.com/dandavison/delta/issues/504
arch=$([[ $(uname -m) == "x86_64" ]] && echo "amd64" || echo "armhf")
curl -fsSL https://github.com/dandavison/delta/releases/download/0.14.0/git-delta${musl}_0.14.0_$arch.deb -o /tmp/git-delta_$arch.deb && sudo dpkg -i /tmp/git-delta_$arch.deb

#######################################################################
# setup nvim config
#######################################################################
echo "Setting up config and installing plugins"
if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    cd "$NVIM_CONFIG_DIR"
    git pull
else
    git clone --depth=1 https://github.com/hanxi/nvim-config.git "$NVIM_CONFIG_DIR"
    cd "$NVIM_CONFIG_DIR"
fi


echo "Installing packer.nvim"
if [[ ! -d ~/.local/share/nvim/site/pack/packer/opt/packer.nvim ]]; then
    git clone --depth=1 https://github.com/wbthomason/packer.nvim \
        ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
fi

echo "Installing nvim plugins, please wait"
"$NVIM_DIR/bin/nvim" -c "autocmd User PackerComplete quitall" -c "PackerSync"

echo "Finished installing Nvim and its dependencies!"
