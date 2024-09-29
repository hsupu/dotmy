
# 默认参数
#

alias ls='ls --color=auto'
# alias dir='dir --color=auto'
# alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# -i for interactive mode
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# -h for human readable figures
alias df='df -h'
alias du='du -h'

# 新别名（带参）
#

# list, long format, show size/type, human-readable
alias l="ls -lFh"
# alias l='ls -CF'
# list all, long list, show size/type, human-readable
alias la="ls -lAFh"
# list all but . ..
# alias la='ls -A'
# list all, long format
alias ll="ls -alF"
# list recursively, sorted by date, show size/type, human-readable
alias lr="ls -tRFh"
# list, long format, sorted by date, show size/type, human-readable
alias lt="ls -ltFh"
# list, sorted by size, show only size/name
alias lS="ls -1FSsh"
# list, reversed sorted by time (oldest first)
alias lrt="ls -1Fcrt"

# history
alias hist="fc -l -D -t '%F %T'"

alias t="tail -f"

# list file sizes in 1-depth subdirs of current dir, human-readable
alias dud="du -d1 -h"
# list file sizes in current dirs, human-readable
alias duf="du -sh"
