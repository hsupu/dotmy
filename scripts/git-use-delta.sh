#!/usr/bin/env bash

# https://github.com/dandavison/delta
# https://dandavison.github.io/delta/introduction.html

git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only --features=interactive"
git config --global add.interactive.useBuiltin "false"
git config --global merge.conflictstyle "diff3"
git config --global diff.colorMoved "default"

# use n/N to move between diffs
git config --global delta.navigate "true"
# dark mode
git config --global delta.light "false"
git config --global delta.line-numbers "true"

git config --global delta.features "decorations"
# git config --global delta.interactive.keep-plus-minus-markers "false"
