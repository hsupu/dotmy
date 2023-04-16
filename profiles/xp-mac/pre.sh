
source_or_warn "$DOTMY/shells/devenv/pre.sh"

PATH_2="${PATH_2}:/usr/local/opt/curl/bin"
PATH_2="${PATH_2}:/usr/local/opt/openssl@1.1/bin"
PATH_2="${PATH_2}:/usr/local/opt/sqlite/bin"

source_or_warn "$DOTMY/shells/devenv/gen-path.sh"
