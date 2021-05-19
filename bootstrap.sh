#! /usr/bin/env bash

set -e
set -x

ETC=~/.local/etc
BIN=~/.local/bin
mkdir -p $ETC
mkdir -p $BIN

# git clone respository
cd ~/.local/
if [ -d dotfiles ]; then
    cd dotfiles
    git pull
else
    git clone https://github.com/hanxi/dotfiles.git
    cd dotfiles
fi
cp -rf etc/* $ETC/
cp -rf bin/* $BIN/
cp bootstrap.sh $BIN/

# install oclip
#curl -s https://oclip.hanxi.info/install | bash -- /dev/stdin eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9 '11111'

# source init.sh
sed -i "\:$ETC/init.sh:d" ~/.bashrc
echo ". $ETC/init.sh" >> ~/.bashrc
. ~/.bashrc

# for neovim
mkdir -p ~/.config/nvim
cp $ETC/init.vim ~/.config/nvim/init.vim

# source vimrc.vim
touch ~/.vimrc
sed -i "\:$ETC/vimrc.vim:d" ~/.vimrc
echo "source $ETC/vimrc.vim" >> ~/.vimrc

# source tmux.conf
touch ~/.tmux.conf
sed -i "\:$ETC/tmux.conf:d" ~/.tmux.conf
echo "source $ETC/tmux.conf" >> ~/.tmux.conf

# update git config
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global core.quotepath false

# install vim plug
if command -v nvim 2>/dev/null; then
    nvim +PlugInstall +qall
else
    vim_version=`vim --version | head -1`
    if [[ `echo $vim_version | awk -F '[ .]' '{print $5}'` -gt 7 ]]; then
        vim +PlugInstall +qall
    fi
fi

