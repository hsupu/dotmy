#!/usr/bin/env bash

pip3 list --outdated --format=freeze | awk -F'==' '{print $1}' | xargs pip3 install -U
