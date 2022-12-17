#!/usr/bin/env bash

while : ; do
    [ -f /tmp/.X0-lock ] && break
    sleep 1 || exit 0
done

x0tigervncserver -display :0 \
	-SecurityTypes none \
	-AlwaysShared
