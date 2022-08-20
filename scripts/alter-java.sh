#!/usr/bin/env bash

if [[ $# < 1 ]]; then
    echo "Usage: [path-to-jdk-root]"
    exit 1
fi

JAVA_HOME="$1"
SBIN="$JAVA_HOME/bin"
DBIN="/usr/bin"

sudo update-alternatives \
    --install "$DBIN/java"    "java"      "$SBIN/java" 50 \
    --slave "$DBIN/jar"       "jar"       "$SBIN/jar" \
    --slave "$DBIN/jarsigner" "jarsigner" "$SBIN/jarsigner" \
    --slave "$DBIN/javac"     "javac"     "$SBIN/javac" \
    --slave "$DBIN/javadoc"   "javadoc"   "$SBIN/javadoc" \
    --slave "$DBIN/javap"     "javap"     "$SBIN/javap" \
    --slave "$DBIN/javaws"    "javaws"    "$SBIN/javaws"

