
source_or_warn "$DOTMY/shells/devenv/pre.sh"

PATH_2="${PATH_2}:/usr/local/opt/curl/bin"
PATH_2="${PATH_2}:/usr/local/opt/openssl@1.1/bin"
PATH_2="${PATH_2}:/usr/local/opt/sqlite/bin"

PATH_4="${PATH_4}:/Applications/VMware Fusion.app/Contents/Public"
PATH_4="${PATH_4}:/Applications/Wireshark.app/Contents/MacOS"
PATH_4="${PATH_4}:/Users/xp/Applications/iTerm.app/Contents/Resources/utilities"
PATH_4="${PATH_4}:/Library/Apple/usr/bin"

source_or_warn "$DOTMY/shells/devenv/gen-path.sh"
