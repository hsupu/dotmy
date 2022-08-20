#!/usr/bin/env bash

if [[ -z $ZSH_CUSTOM ]]; then
    export ZSH_CUSTOM="$ZSH/custom"
fi

# git clone --single-branch --branch master https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone --single-branch --branch master https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
git clone --single-branch --branch master https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
