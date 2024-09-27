#!/usr/bin/env bash

scutil --get HostName 
scutil --get LocalHostName 
scutil --get ComputerName

return

# Primary hostname, full qualified. e.g. xp-mac.lan
sudo scutil --set HostName $HOSTNAME

# Bonjour hostname, on local network. e.g. xp-mac for xp-mac.local
sudo scutil --set LocalHostName $HOSTNAME

# e.g. xp-mac
sudo scutil --set ComputerName $HOSTNAME
