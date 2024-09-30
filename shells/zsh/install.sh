#!/usr/bin/env bash

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR="$curdir"

pushd "${ZDOTDIR:-$HOME}"

BACKUP_PREFIX=$(date +"%Y-%M-%dT%T%z")
mv .zlogin      "${BACKUP_PREFIX}.zlogin"
mv .zlogout     "${BACKUP_PREFIX}.zlogout"
mv .zprofile    "${BACKUP_PREFIX}.zprofile"
mv .zshenv      "${BACKUP_PREFIX}.zshenv"
mv .zshrc       "${BACKUP_PREFIX}.zshrc"

ln -sf "${SHRC_DIR}/zlogin.sh"      .zlogin
ln -sf "${SHRC_DIR}/zlogout.sh"     .zlogout
ln -sf "${SHRC_DIR}/zprofile.sh"    .zprofile
ln -sf "${SHRC_DIR}/zshenv.sh"      .zshenv
ln -sf "${SHRC_DIR}/zshrc.sh"       .zshrc

popd

TARGET_SHELL=zsh
if [[ "$(basename "$(sh -c "echo \$SHELL")")" == $TARGET_SHELL ]]; then
    echo "Already set $TARGET_SHELL as default shell"
else
    echo "Setting $TARGET_SHELL as user shell"
    chsh -s "$(which $TARGET_SHELL)" $USER
fi
