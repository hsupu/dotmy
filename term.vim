
" 同步修改终端标题
set title

" 禁用光标闪烁
set novisualbell
" 开启声音通知
set errorbells

if has('mouse')
    " 在特定模式启用鼠标 n=normal v=visual i=insert c=command h=help a=all A=auto
    set mouse=nv
endif

if exists('$TMUX')
    " 支持 tmux 动态放缩
    set ttymouse=xterm2
endif
