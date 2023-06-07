#! /usr/bin/env bash

set -e
set -x

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
CYGWIN*) machine=Cygwin ;;
MINGW*) machine=MinGw ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac
echo ${machine}

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

if [ $machine == "Linux" ]; then
	echo "install nvim"
	bash ~/.local/dotfiles/setup_ubuntu2204.sh
fi

# source init.sh
sed -i "\:$ETC/init.sh:d" ~/.bashrc
echo ". $ETC/init.sh" >>~/.bashrc
. ~/.bashrc

# source vimrc.vim
touch ~/.vimrc
sed -i "\:$ETC/vimrc.vim:d" ~/.vimrc
echo "source $ETC/vimrc.vim" >>~/.vimrc

# source tmux.conf
touch ~/.tmux.conf
sed -i "\:$ETC/tmux.conf:d" ~/.tmux.conf
echo "source $ETC/tmux.conf" >>~/.tmux.conf

# update git config
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global core.quotepath false
git config --global push.default simple
git config --global core.autocrlf false
git config --global core.ignorecase false
git config --global core.pager delta
git config --global interactive.diffFilter delta
git config --global add.interactive.useBuiltin false
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

# install vim plug
vim_version=$(\vim --version | head -1)
if [[ $(echo $vim_version | awk -F '[ .]' '{print $5}') -gt 7 ]]; then
	\vim +PlugInstall +qall
fi

# install wezterm
rm -rf ~/.config/wezterm
mkdir -p ~/.config
ln -s $ETC/wezterm ~/.config/wezterm

# install stylua config
rm -rf ~/.config/stylua
ln -s $ETC/stylua ~/.config/stylua
