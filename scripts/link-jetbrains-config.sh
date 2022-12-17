#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
MYROOT=$(realpath "${SCRIPT_DIR}/../")

VER=2019.3

mkdir -p "$HOME/.CLion$VER"
ln -s "$MYROOT/etc/clion" -T "$HOME/.CLion$VER/config"

