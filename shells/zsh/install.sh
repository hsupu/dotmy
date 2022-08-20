
if [[ -n $BASH_VERSION ]]; then
  curdir="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
elif [[ -n $ZSH_VERSION ]]; then
  curdir="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
fi
export SHRC_DIR=$curdir

rm $HOME/.zshrc
rm $HOME/.zlogin
rm $HOME/.zlogout

ln -sf "${SHRC_DIR}/zshrc.sh" "$HOME/.zshrc"
ln -sf "${SHRC_DIR}/zlogin.sh" "$HOME/.zlogin"
ln -sf "${SHRC_DIR}/zlogout.sh" "$HOME/.zlogout"

chsh -s $(which zsh) $USER
