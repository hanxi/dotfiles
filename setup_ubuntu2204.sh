#!/bin/bash
set -exu
set -o pipefail

USE_CACHE=false
USE_CACHE=true

#######################################################################
# install pre
#######################################################################
sudo apt install -y gcc make g++ tmux bison bash-completion subversion tig

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
# Install node and js-based language server
#######################################################################
NODE_DIR=$HOME/.local/tools/nodejs
NODE_SRC_NAME=$HOME/.local/packages/nodejs.tar.gz
# when download speed is slow, we can also use its mirror site: https://mirrors.ustc.edu.cn/node/v19.0.0/
NODE_LINK="https://mirrors.ustc.edu.cn/node/v19.0.0/node-v19.0.0-linux-x64.tar.xz"

echo "Install Node.js"
if [[ "$USE_CACHE" = false || ! -f $NODE_SRC_NAME ]]; then
    echo "Downloading Node.js and renaming"
    wget $NODE_LINK -O "$NODE_SRC_NAME"
fi

if [[ "$USE_CACHE" = false || ! -d "$NODE_DIR" ]]; then
    echo "Creating Node.js directory under tools directory"
    mkdir -p "$NODE_DIR"
    echo "Extracting to $HOME/.local/tools/nodejs directory"
    tar xvf "$NODE_SRC_NAME" -C "$NODE_DIR" --strip-components 1
fi

sed -i "\:"$NODE_DIR/bin":d" "$HOME/.bashrc"
echo "export PATH=\"$NODE_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"

export PATH="$NODE_DIR/bin:$PATH"

# Install vim-language-server
"$NODE_DIR/bin/npm" install -g vim-language-server

# Install bash-language-server
"$NODE_DIR/bin/npm" install -g bash-language-server

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

# install clangd
sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
sudo ln -sfT $(ls -1 /usr/bin/clangd* | tail -1) /usr/bin/clangd

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

# install gvm
curl https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash \
    && source $HOME/.gvm/scripts/gvm && gvm install go1.4 -B \
    && gvm use go1.4 \
    && export GOROOT_BOOTSTRAP=$GOROOT \
    && gvm install go1.18 \
    && gvm use go1.18 --default \
	&& go install golang.org/x/tools/gopls@latest

# install delta
musl=$([[ $(lsb_release -r | cut -f2) == "20.04" ]] && echo "" || echo "-musl") # https://github.com/dandavison/delta/issues/504
arch=$([[ $(uname -m) == "x86_64" ]] && echo "amd64" || echo "armhf")
curl -fsSL https://github.com/dandavison/delta/releases/download/0.14.0/git-delta${musl}_0.14.0_$arch.deb -o /tmp/git-delta_$arch.deb && sudo dpkg -i /tmp/git-delta_$arch.deb

#######################################################################
# setup nvim config
#######################################################################
### echo "Setting up config and installing plugins"
### if [[ -d "$NVIM_CONFIG_DIR" ]]; then
###     rm -rf "$NVIM_CONFIG_DIR.backup"
###     mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.backup"
### fi
###
### git clone --depth=1 https://github.com/hanxi/nvim-config.git "$NVIM_CONFIG_DIR"
###
### echo "Installing packer.nvim"
### if [[ ! -d ~/.local/share/nvim/site/pack/packer/opt/packer.nvim ]]; then
###     git clone --depth=1 https://github.com/wbthomason/packer.nvim \
###         ~/.local/share/nvim/site/pack/packer/opt/packer.nvim
### fi
###
### echo "Installing nvim plugins, please wait"
### "$NVIM_DIR/bin/nvim" -c "autocmd User PackerComplete quitall" -c "PackerSync"
###
### echo "Finished installing Nvim and its dependencies!"
