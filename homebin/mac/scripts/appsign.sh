#!/usr/bin/env bash

sudo codesign --force --deep --sign - "$1"

