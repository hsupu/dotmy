#!/usr/bin/env bash

DOTMY=$HOME/.config/dotmy
SHRC_DIR=$DOTMY/raw-linux/bash

rm $HOME/.bashrc
rm $HOME/.bash_profile
rm $HOME/.bash_logout

ln -s "${SHRC_DIR}/bashrc.sh" $HOME/.bashrc
ln -s "${SHRC_DIR}/profile.sh" $HOME/.bash_profile
ln -s "${SHRC_DIR}/logout.sh" $HOME/.bash_logout
