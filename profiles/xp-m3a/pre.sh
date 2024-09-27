
eval "$(/opt/homebrew/bin/brew shellenv)"

source_or_warn "$DOTMY/shells/devenv/pre.sh"

PATH_1="${PATH_1}:/opt/homebrew/bin:/opt/homebrew/sbin"

PATH_2="${PATH_2}:/usr/local/opt/curl/bin"
PATH_2="${PATH_2}:/usr/local/opt/openssl@1.1/bin"
PATH_2="${PATH_2}:/usr/local/opt/sqlite/bin"
PATH_2="${PATH_2}:/System/Cryptexes/App/usr/bin"

PATH_4="${PATH_4}:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"
PATH_4="${PATH_4}:/Applications/iTerm.app/Contents/Resources/utilities"

source_or_warn "$DOTMY/shells/devenv/gen-path.sh"
