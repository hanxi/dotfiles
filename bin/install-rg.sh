#! /usr/bin/env bash

mkdir -p ~/app-src
cd ~/app-src

version=0.10.0
dir_name=ripgrep-${version}-x86_64-unknown-linux-musl
file_name=${dir_name}.tar.gz
if [ ! -f ${file_name} ]; then
    wget -O ${file_name} https://github.com/BurntSushi/ripgrep/releases/download/${version}/${file_name}
    tar -zxvf ${file_name}
fi

cp ${dir_name}/rg ~/.local/bin/
cp ${dir_name}/rg ~/.local/dotfiles/bin/

