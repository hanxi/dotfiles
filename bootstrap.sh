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

is_debian_12() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$NAME" == "Debian GNU/Linux" && "$VERSION_ID" == "12" ]]; then
            return 0
        fi
    fi
    return 1
}

if is_debian_12; then
    echo "当前系统是 Debian 12"
fi

is_ubuntu_2204() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$NAME" == "Ubuntu" && "$VERSION_ID" == "22.04" ]]; then
            return 0
        fi
    fi
    return 1
}

# 执行判断
if is_ubuntu_2204; then
    echo "当前系统是 Ubuntu 22.04"
fi



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

if is_debian_12; then
	echo "install package"
	bash ~/.local/dotfiles/setup_debian12.sh
fi

if is_ubuntu_2204; then
	echo "install package"
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
git config --global pull.rebase true

# install vim plug
#vim_version=$(\vim --version | head -1)
#if [[ $(echo $vim_version | awk -F '[ .]' '{print $5}') -gt 7 ]]; then
#	\vim +PlugInstall +qall
#fi

# install wezterm
rm -rf ~/.config/wezterm
mkdir -p ~/.config
ln -s $ETC/wezterm ~/.config/wezterm

# install stylua config
rm -rf ~/.config/stylua
ln -s $ETC/stylua ~/.config/stylua
