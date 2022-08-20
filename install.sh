#!/usr/bin/env bash

GIT_URL=git@gitee.com:hsupu/myvim.git

echo "安装 vim"
sudo apt install vim

echo "配置 vim"
git clone --single-branch --branch master ${GIT_URL} "$HOME/.vim"

echo "本机定制配置请写入 $HOME/.vim/vimrc.custom"
touch "$HOME/.vim/vimrc.custom"
