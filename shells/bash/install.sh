
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi
export SHRC_DIR=$curdir

rm $HOME/.bashrc
rm $HOME/.bash_profile
rm $HOME/.bash_login
rm $HOME/.bash_logout

ln -sf "${SHRC_DIR}/bashrc.sh" "$HOME/.bashrc"
ln -sf "${SHRC_DIR}/profile.sh" "$HOME/.bash_profile"
ln -sf "${SHRC_DIR}/login.sh" "$HOME/.bash_login"
ln -sf "${SHRC_DIR}/logout.sh" "$HOME/.bash_logout"

chsh -s $(which bash) $USER
