#!/usr/bin/env bash

MYDIR="$(cd "$(dirname "$0")"; pwd)"
pushd "$MYDIR"

JAVA_BIN="./jre/bin/java"
JVM_OPTS="-Xms1024M -Xmx3600M"
JAR="./fabric-server-launch.jar"
PORT=25565

$JAVA_BIN $JVM_OPTS \
    -jar $JAR \
    nogui \
    port $PORT \
    $@

popd
