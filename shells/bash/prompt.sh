
## 配置 PS1 - 内容和颜色
## https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html#Controlling-the-Prompt
#
# \D - https://strftime.org/
# \h - hostname
# \u - username
# \w - workdir ; \W - basename of $PWD

# if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

case "$TERM" in
    xterm-color|*-256color) bash_with_color=y ;;
esac

if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
    bash_with_color=y
else
    bash_with_color=
fi

if [[ -n $bash_with_color ]]; then
    # 终端支持颜色，假定与标准 Ecma-48 (ISO/IEC-6429) 兼容
    PS1NC='\u@\h:\w\$ '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    unset bash_with_color
else
    # 终端不支持颜色
    PS1NC='\u@\h:\w\$ '
    PS1=$PS1NC
fi
PS1="\${debian_chroot:+(\$debian_chroot)}$PS1"
unset bash_with_color

# 为 xterm 添加一组控制字符，用于向终端提示本行有几个字符已占用
# \e - ASCII escape
# \a - ASCII bell
case "$TERM" in
    xterm*|rxvt*) PS1="\[\e]0;$PS1NC\a\]$PS1" ;;
    *) ;;
esac
