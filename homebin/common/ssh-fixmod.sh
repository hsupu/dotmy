#!/usr/bin/env bash

pushd ~/.ssh

chmod 0644 config config.d/*
chmod 0644 id_ecdsa id_ed25519 id_rsa

