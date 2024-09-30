#!/usr/bin/env bash

echo "Setting bash as user shell"

curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export SHRC_DIR="$curdir"

pushd $HOME

BACKUP_PREFIX=$(date +"%Y-%M-%dT%T%z")
mv .bashrc          "${BACKUP_PREFIX}.bashrc"
mv .bash_profile    "${BACKUP_PREFIX}.bash_profile"
mv .bash_login      "${BACKUP_PREFIX}.bash_login"
mv .bash_logout     "${BACKUP_PREFIX}.bash_logout"

ln -sf "${SHRC_DIR}/bashrc.sh"      .bashrc
ln -sf "${SHRC_DIR}/profile.sh"     .bash_profile
ln -sf "${SHRC_DIR}/login.sh"       .bash_login
ln -sf "${SHRC_DIR}/logout.sh"      .bash_logout

popd

TARGET_SHELL=bash
if [[ "$(basename "$(sh -c "echo \$SHELL")")" == $TARGET_SHELL ]]; then
    echo "Already set $TARGET_SHELL as default shell"
else
    echo "Setting $TARGET_SHELL as user shell"
    chsh -s "$(which $TARGET_SHELL)" $USER
fi
