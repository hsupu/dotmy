#!/usr/bin/env bash

VER=3.6.2

URL=http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/$VER/binaries/apache-maven-$VER-bin.tar.gz
FILE=/tmp/apache-maven-$VER.tar.gz

INSTALL_DIR=/opt
ZIP_DIR=apache-maven-$VER

wget -O $FILE $URL || exit 1

tar -x -f $FILE \
    -C "$INSTALL_DIR"
    --one-top-level="$ZIP_DIR" \
    --strip-components=1 \
    || exit 1

