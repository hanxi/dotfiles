#! /usr/bin/env bash

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
    git clone git@github.com:hanxi/dotfiles.git
    cd dotfiles
fi
cp -rf etc/* $ETC/
cp -rf bin/* $BIN/
cp bootstrap.sh $BIN/

# setup lemonade
# TODO check sys_type
sys_type=linux_amd64
rm -f $BIN/lemonade
ln -s $BIN/lemonade_${sys_type} $BIN/lemonade
mkdir -p ~/.config
cp $ETC/lemonade.toml ~/.config/lemonade.toml

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

# install vim plug (may be some bugs)
nvim +PlugInstall +qall

