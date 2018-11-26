#! /usr/bin/env bash

version=2.19.2
download_file_name=v${version}.tar.gz
file_name=git-${version}.tar.gz

mkdir -p ~/app-src
cd ~/app-src

if [ ! -f ${file_name} ]; then
    wget -O ${file_name} https://github.com/git/git/archive/${download_file_name}
    tar -zxvf ${file_name}
fi

# TODO: check system
# Ubuntu
# sudo apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
# cd ~/app-src/git-${version}
# make prefix=$HOME/.local/ install

# TODO: check system
# CentOS
# sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
# sudo yum install  gcc perl-ExtUtils-MakeMaker
# cd ~/app-src
# wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz
# tar -zxvf libiconv-1.15.tar.gz
# ./configure --prefix=$HOME/.local
# make install
# cd ~/app-src/git-${version}
# make configure
# ./configure --prefix=$HOME/.local --with-iconv=$HOME/.local/lib
# make install

