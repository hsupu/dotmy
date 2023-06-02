#!/usr/bin/env bash
# https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
pushd $SCRIPT_DIR

items=$(find . -type l | grep '')

popd
