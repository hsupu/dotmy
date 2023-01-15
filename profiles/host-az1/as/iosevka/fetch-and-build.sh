#!/usr/bin/env bash

#TAG=v7.2.6
TAG=$(/as/bin/fetch-github-latest-release-tag.ps1 be5invis/Iosevka | sed -s 's/^[[:space:]]*//')

if [[ ! ${TAG:0:1} == 'v' ]]; then
    echo "WRONG:$TAG"
fi

mkdir -p src
pushd src

URL=https://github.com/be5invis/Iosevka/archive/refs/tags/$TAG.tar.gz
wget $URL -O - | tar -zx -C . --strip-components=1
npm install
ln -s /as/build/conf/iosevka-pu.private-build-plans.toml private-build-plans.toml
npm run build -- ttf::iosevka-pu
cd dist/iosevka-pu
tar -cz -f ttf.tar.gz ttf
popd

