#!/usr/bin/env bash

for dir in */; do
    pushd "$dir"
    # git branch | grep -e"^*"
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "git fetch origin $branch"
    git fetch origin $branch
    LASTEXITCODE=$?
    if [[ 0 == $LASTEXITCODE ]]; then
        git checkout FETCH_HEAD
    fi
    popd
done
