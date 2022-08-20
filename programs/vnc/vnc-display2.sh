#!/usr/bin/env bash

while : ; do
    [ -f /tmp/.X0-lock ] && break
    sleep 1 || exit 0
done

tigervncserver :2 -fg -SecurityTypes none
