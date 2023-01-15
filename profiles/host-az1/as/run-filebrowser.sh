#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd)
pushd "$SCRIPT_DIR"

./filebrowser \
	--root /as/dl \
	--database filebrowser.db \
	--address 0.0.0.0 \
	--port 40010 \
	--baseurl / \
	--log filebrowser.log \

popd
