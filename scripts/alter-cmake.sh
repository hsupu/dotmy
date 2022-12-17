#!/usr/bin/env bash

SDIR=/as/app/cmake/bin
DDIR=/usr/local/bin

PRIOR=$1

update-alternatives \
    --install $DDIR/cmake cmake $SDIR/cmake $PRIOR \
    --slave $DDIR/cmake-gui cmake-gui $SDIR/cmake-gui \
    --slave $DDIR/ccmake ccmake $SDIR/ccmake \
    --slave $DDIR/cpack cpack $SDIR/cpack \
    --slave $DDIR/ctest ctest $SDIR/ctest
