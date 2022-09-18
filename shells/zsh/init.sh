#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR=$curdir

# 安装 zsh
sudo apt install -y zsh

# 安装 oh-my-zsh
#

if [[ -z $ZSH ]]; then
    mkdir -p $HOME/.config
    ZSH=$HOME/.config/oh-my-zsh
fi
echo "ZSH=$ZSH"

export ZSH
curl -L https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash

# 安装插件
${SHRC_DIR}/init-plugins.sh

# 启用 zsh
${SHRC_DIR}/install.sh
