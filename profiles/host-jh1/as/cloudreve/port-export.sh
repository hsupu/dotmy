#!/usr/bin/env bash

IP=194.156.121.172
socat TCP-LISTEN:5212,fork,reuseaddr,bind=$IP TCP4:127.0.0.1:5212
