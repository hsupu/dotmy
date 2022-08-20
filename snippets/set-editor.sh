#!/usr/bin/env bash

# for vscode: "code --wait"
# for sublime: "subl --wait"

export EDITOR="vim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

git config --global core.editor "$EDITOR"
