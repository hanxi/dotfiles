#! /usr/bin/env bash

# update lemonade
# see https://github.com/pocke/lemonade/releases
function update_lemonade()
{
    version=$1 # v1.1.1
    sys_type=$2 # linux_amd64
    file_name=lemonade_${sys_type}.tar.gz
    wget https://github.com/pocke/lemonade/releases/download/${version}/${file_name}
    tar -zxvf ${file_name}
    rm -f ${file_name}
    mv lemonade bin/lemonade_${sys_type}
}

# TODO check sys_type
update_lemonade v1.1.1 linux_amd64

