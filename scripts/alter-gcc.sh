#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "Usage: [version-code]"
    exit 1
fi

VER="$1"
SDIR="/usr/bin"
DDIR="/usr/bin"

sudo update-alternatives \
    --install "$DDIR/gcc"        "gcc"        "$SDIR/gcc-$VER" 50 \
    --slave   "$DDIR/cc"         "cc"         "$SDIR/gcc-$VER" \
    --slave   "$DDIR/cpp"        "cpp"        "$SDIR/cpp-$VER" \
    --slave   "$DDIR/g++"        "g++"        "$SDIR/g++-$VER" \
    --slave   "$DDIR/gcc-ar"     "gcc-ar"     "$SDIR/gcc-ar-$VER" \
    --slave   "$DDIR/gcc-nm"     "gcc-nm"     "$SDIR/gcc-nm-$VER" \
    --slave   "$DDIR/gcc-ranlib" "gcc-ranlib" "$SDIR/gcc-ranlib-$VER"

