#!/usr/bin/env bash

TARGET_DIR=$(dirname "$DOTMY/programs/$2")
TARGET_BASENAME=$(basename "$2")
TARGET="${TARGET_DIR}/${TARGET_BASENAME}"

mkdir -p "${TARGET_DIR}"
mv "$1" "$TARGET"
ln -s "$TARGET" "$1"
