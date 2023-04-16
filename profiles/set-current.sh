#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
pushd $SCRIPT_DIR

TARGET=$(hostname -s)
ln -sf $TARGET current 

popd
