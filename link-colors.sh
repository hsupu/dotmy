#!/usr/bin/env bash

echo "Please install plguins first"

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
pushd "${SCRIPT_DIR}/colors"

ln -sf ../plugged/vim-dzo/colors/dzo.vim ./
ln -sf ../plugged/molokai/colors/molokai.vim ./
ln -sf ../plugged/vim-quantum/colors/quantum.vim ./

popd
