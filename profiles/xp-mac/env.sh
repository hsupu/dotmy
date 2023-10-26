
export DOTMY="$HOME/.config/dotmy"
[[ -d $DOTMY ]] || echo "\$DOTMY not found: $DOTMY"

export DOTMY_PROFILE="xp-mac"

# editor
export EDITOR="vim"
export VISUAL="$EDITOR"

# golang
export GOPATH="$HOME/.local/golang"
# java
export JAVA_HOME="/Library/Java/Home"
# php
export COMPOSER_HOME="$HOME/.local/composer"
# python
# pyenv data dir
export PYENV_ROOT="$HOME/.local/pyenv"
# node
# nvm data dir - avoid losing installations when "brew upgrade nvm"
export NVM_DIR="$HOME/.local/nvm"
# ruby
# rbenv data dir
export RBENV_ROOT="$HOME/.local/rbenv"
# rust
export CARGO_HOME="$HOME/.local/cargo"
export RUSTUP_HOME="$HOME/.local/rustup"
# vim
# export VIMRUNTIME="/usr/local/opt/vim/share/vim/vim90"
# export VIMINIT="$HOME/.vim/vimrc"
