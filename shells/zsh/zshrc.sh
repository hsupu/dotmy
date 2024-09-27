function source_or_warn() {
    if [[ -e $1 ]]; then
        . "$1" || echo "source failed: $1"
    else
        echo "source not found: $1"
    fi
}

function source_or_skip() {
    if [[ -e $1 ]]; then
        . "$1" || echo "source failed: $1"
    fi
}

alias safe_source=source_or_warn

# https://unix.stackexchange.com/questions/4650/determining-path-to-sourced-shell-script
# ${BASH_SOURCE[0]:-${(%):-%x}}

# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Modifiers
# :A for 1) absolute path 2) resolve symlink
# ${0:A}

# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
export SHRC_DIR="$(cd "$(dirname "$(realpath ${(%):-%x})")"; pwd)"
export MYZSH="${SHRC_DIR}"

### My

unset PATH_0
unset PATH_1
unset PATH_2
unset PATH_3
unset PATH_4

source_or_skip "$HOME/.config/shell/env.sh"
source_or_skip "$HOME/.config/shell/pre.sh"
source_or_skip "$HOME/.config/shell/pre-zsh.sh"

if [[ ! -d $ZSH ]]; then
    [[ -n $ZSH ]] && echo "\$ZSH invalid: $ZSH"

    [[ -d $ZSH ]] || ZSH="$HOME/.local/oh-my-zsh"
    # [[ -d $ZSH ]] || ZSH="$HOME/.local/omz"
    [[ -d $ZSH ]] || ZSH="$HOME/.config/oh-my-zsh"
    # [[ -d $ZSH ]] || ZSH="$HOME/.config/omz"
    [[ -d $ZSH ]] || ZSH="$HOME/.oh-my-zsh"

    [[ -d $ZSH ]] && export ZSH || echo "\$ZSH not found"
fi
[[ -z $ZSH_CUSTOM ]] && export ZSH_CUSTOM="$ZSH/custom"
[[ -z $ZSH_CACHE_DIR ]] && export ZSH_CACHE_DIR="$ZSH/cache"

source_or_skip "$HOME/.config/shell/pre-omz.sh"

### 插件管理
# 标准插件在 $ZSH/plugins 目录下
# 自定义的插件可以放到 $ZSH_CUSTOM/plugins 目录里

plugins=()
function add_plugin() {
    plugins=($plugins $@)
}
add_plugin ansible
add_plugin colored-man-pages
add_plugin colorize
add_plugin encode64
add_plugin gitfast git-prompt
add_plugin rust
add_plugin shell-proxy
add_plugin sudo
add_plugin timer
add_plugin tmux

# https://github.com/zsh-users/zsh-completions/issues/603
# add_plugin zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# 这必须是最后一个插件
add_plugin zsh-syntax-highlighting

## 插件配置

# shell-proxy
CONFIG_PROXY="${SHRC_DIR}/proxy.sh"

# timer
TIMER_FORMAT="/%d"
TIMER_PRECISION=2
# 至少多少秒后才显示计时器
TIMER_THRESHOLD=1

### 补全与捕获

# 是否大小写敏感
# CASE_SENSITIVE="true"
# 如果大小写不敏感的话，是否允许连字符不敏感，即 _ - 可以互换
HYPHEN_INSENSITIVE="true"

# 是否启用命令纠错
# ENABLE_CORRECTION="true"

# 是否在等待补全结果时显示红点
# 使用 multiline prompts 时可能会有问题（zsh 5.7.1 之前的版本）
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# 补全缓存文件路径
# ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

# 输入路径时自动 cd
setopt autocd

# 启用拓展捕获模式
setopt extendedglob

# 捕获失败时报错，而非静默
setopt nomatch

### 外观

# 主题
# https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gianu"

# 是否禁用 ls 命令的着色
# DISABLE_LS_COLORS="true"

# 是否禁用终端标题与当前命令的自动同步
# DISABLE_AUTO_TITLE="true"

### 历史记录

# 历史记录文件
HISTFILE="$HOME/.local/histfile"
# 最大历史记录数
HISTSIZE=1000
# 注销后保留的历史记录数
SAVEHIST=1000
# 额外记录时间戳和持续时间
setopt extended_history
# 时间戳格式（自定义参见：man strftime）
HIST_STAMPS="yyyy-mm-dd"
# 都追加到同一文件里
setopt appendhistory
# 随时保存，不仅是 zsh 退出时
#setopt inc_append_history
# 忽略新出现的重复项
setopt hist_ignore_dups
# 历史记录包括注释
setopt interactive_comments
# 共享历史记录
setopt share_history

### 特性

# 是否不再标记 VCS 程序未追踪的脏文件（可提高大型仓库的检查速度）
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

### Oh-My-Zsh

# 是否禁用自动更新检查
DISABLE_AUTO_UPDATE="true"
# 是否自动更新，而不是提示更新
DISABLE_UPDATE_PROMPT="false"
# 自动更新的检查间隔（按天计）
# UPDATE_ZSH_DAYS=13
# 开启 Oh My ZSH !
. $ZSH/oh-my-zsh.sh

### My

source_or_skip "$HOME/.config/shell/post.sh"
source_or_skip "$HOME/.config/shell/post-zsh.sh"
source_or_skip "$HOME/.config/shell/post-omz.sh"

### END
