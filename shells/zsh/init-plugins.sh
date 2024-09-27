#!/usr/bin/env bash

if [[ -z $ZSH_CUSTOM ]]; then
    export ZSH_CUSTOM="${ZSH:-~/.oh-my-zsh}/custom"
fi

# git clone --single-branch --branch master https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions
git clone --single-branch --branch master https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone --single-branch --branch master https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-syntax-highlighting
