#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR=$curdir

rm $HOME/.zshrc
rm $HOME/.zlogin
rm $HOME/.zlogout

ln -sf "${SHRC_DIR}/zshrc.sh" "$HOME/.zshrc"
ln -sf "${SHRC_DIR}/zlogin.sh" "$HOME/.zlogin"
ln -sf "${SHRC_DIR}/zlogout.sh" "$HOME/.zlogout"

chsh -s $(which zsh) $USER
