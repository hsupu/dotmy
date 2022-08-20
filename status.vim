" 显示标尺（光标位置的行号和列号）
set ruler
" 状态栏行数
set laststatus=2
" 状态栏信息
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\ 

" 显示输入状态（NORMAL VISUAL INSERT）
set showmode
" 显示命令补全
set showcmd

" 增强命令行补全
set wildmenu
set wildmode=list:longest

" 历史记录条数
set history=500
