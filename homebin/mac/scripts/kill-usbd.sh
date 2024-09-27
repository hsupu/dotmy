#!/usr/bin/env bash

# 似乎旧 mac（至少 MBP 2015 是）在 USB 电源管理方面有 bug，供电不足
sudo killall -STOP -c usbd

