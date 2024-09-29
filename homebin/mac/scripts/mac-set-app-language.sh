#!/usr/bin/env bash

LANGUAGE=$1; shift
echo "defaults write com.brunophilipe.Cakebrew AppleLanguages (\"$LANGUAGE\")"
