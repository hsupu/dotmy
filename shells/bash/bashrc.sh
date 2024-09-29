# ~/.bashrc: executed by bash(1) for non-login shells.
#
# see example in /usr/share/doc/bash-doc/examples (install package "bash-doc" first)


# exit if not interactively
[[ "$-" != *i* ]] && return
# case $- in
#     *i*) ;;
#       *) return;;
# esac


function source_or_warn() {
    if [[ -s "$1" ]]; then
        . "$1"
    else
        echo "source: not found: $1"
    fi
}

function source_or_skip() {
    [[ -s "$1" ]] && . "$1"
}

alias safe_source=source_or_warn

export SHRC_DIR="$(cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"; pwd)"
export DOTMY="$(cd "${SHRC_DIR}/../.."; pwd)"


# source "$HOME/.config/shell/env.sh" and gen $PATH inside
source_or_warn "$DOTMY/profiles/base/env.sh"

source_or_skip "$HOME/.config/shell/pre.sh"
source_or_skip "$HOME/.config/shell/pre-bash.sh"

# 交互
#
# 每条命令后都重新检测当前窗口大小（更新环境变量 LINES COLUMNS）
shopt -s checkwinsize
# Don't wait for job termination notification
#set -o notify
# 忽略 EOF(^D) 作为退出信号（这是 Ctrl+Z 即 Windows 风格曾用过的退出命令）
set -o ignoreeof

# readline bindings
# 忽略大小写
bind "set completion-ignore-case on"
# "-_" 视同
bind "set completion-map-case on"
# 二义时显示所有
bind "set show-all-if-ambiguous on"
# 立即解析目录的符号链接并追加后缀 "/"
bind "set mark-symlinked-directories on"

# 使 less 命令对非文本文件更友好, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ -x /usr/bin/dircolors ]]; then
    [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# 命令历史
#
# ignoredups=忽略重复行 erasedups=删除旧重复行 ignorespace=忽略有空格打头的行
HISTCONTROL=erasedups:ignorespace
# 忽略常见无参命令（以 ":" 分割）
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls:history:clear'
# 设置命令历史的命令/文件长度限制
HISTSIZE=1000
HISTFILESIZE=20000
# 时间戳格式（这里是 ISO-8601 format，%F=%Y-%m-%d, %T=%H:%M:%S 24h）
HISTTIMEFORMAT="%F %T "
# 追加而非覆盖命令历史文件
shopt -s histappend
# 多行命令视为一条
shopt -s cmdhist

# 命令补全
#
# 为 cd 启用自动纠错（如 /vr/lgo/apaache -> /var/log/apache）
# shopt -s cdspell
# 为 tab 补全启用自动纠错
# shopt -s dirspelll

# 路径补全（文件名匹配 filename globbing）
#
# 启用 "**" 作为路径展开符，用于匹配任意数量的文件和子目录
#shopt -s globstar
# 忽略大小写
shopt -s nocaseglob

source_or_warn "${SHRC_DIR}/prompt.sh"

source_or_skip "$HOME/.config/shell/post.sh"
source_or_skip "$HOME/.config/shell/post-bash.sh"

# 加载命令补全脚本（bash_completion 也只是个入口）
#
if [[ "x$NO_BASH_COMPLETION" != "xno" ]]; then
  if ! shopt -oq posix ; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
  fi
fi
