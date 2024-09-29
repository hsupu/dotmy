#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR=$curdir

SUFFIX=$(date +"%Y-%M-%dT%T%z")
mv "$HOME/.zlogin" "$HOME/.zlogin.$SUFFIX"
mv "$HOME/.zlogout" "$HOME/.zlogout.$SUFFIX"
mv "$HOME/.zprofile" "$HOME/.zprofile.$SUFFIX"
mv "$HOME/.zshenv" "$HOME/.zshenv.$SUFFIX"
mv "$HOME/.zshrc" "$HOME/.zshrc.$SUFFIX"

ln -sf "${SHRC_DIR}/zlogin.sh" "$HOME/.zlogin"
ln -sf "${SHRC_DIR}/zlogout.sh" "$HOME/.zlogout"
ln -sf "${SHRC_DIR}/zprofile.sh" "$HOME/.zprofile"
ln -sf "${SHRC_DIR}/zshenv.sh" "$HOME/.zshenv"
ln -sf "${SHRC_DIR}/zshrc.sh" "$HOME/.zshrc"

TARGET_SHELL=zsh
if [[ "$(basename "$(sh -c "echo \$SHELL")")" == $TARGET_SHELL ]]; then
    echo "Already set $TARGET_SHELL as default shell"
else
    echo "Setting $TARGET_SHELL as user shell"
    chsh -s "$(which $TARGET_SHELL)" $USER
fi
