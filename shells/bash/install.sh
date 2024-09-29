#!/usr/bin/env bash

echo "Setting bash as user shell"

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR=$curdir

SUFFIX=$(date +"%Y-%M-%dT%T%z")
mv "$HOME/.bashrc" "$HOME/.bashrc.$SUFFIX"
mv "$HOME/.bash_profile" "$HOME/.bash_profile.$SUFFIX"
mv "$HOME/.bash_login" "$HOME/.bash_login.$SUFFIX"
mv "$HOME/.bash_logout" "$HOME/.bash_logout.$SUFFIX"

ln -sf "${SHRC_DIR}/bashrc.sh" "$HOME/.bashrc"
ln -sf "${SHRC_DIR}/profile.sh" "$HOME/.bash_profile"
ln -sf "${SHRC_DIR}/login.sh" "$HOME/.bash_login"
ln -sf "${SHRC_DIR}/logout.sh" "$HOME/.bash_logout"

TARGET_SHELL=bash
if [[ "$(basename "$(sh -c "echo \$SHELL")")" == $TARGET_SHELL ]]; then
    echo "Already set $TARGET_SHELL as default shell"
else
    echo "Setting $TARGET_SHELL as user shell"
    chsh -s "$(which $TARGET_SHELL)" $USER
fi
