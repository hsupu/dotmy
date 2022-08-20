
" 允许退格符删除回车、缩进和 start
set backspace=indent,eol,start
" 允许方向键跨越行边界
"set whichwrap+=<,>,h,l

" 显示行号
"set number
" 高亮显示当前行
set cursorline

" 光标移动到上下边界时保留多行
set scrolloff=3

""" 代码格式相关
"""

" 开启语法高亮
syntax on

" 粘贴时保持原格式
set paste

" 自动缩进
set autoindent
" 新行智能缩进
set smartindent
" 使用代码缩进
set cindent
" 设置缩进宽度
set shiftwidth=4
" 用空格（space）替换制表符（tab）
set expandtab
" 转换时 1 tab 等于 4 space
set tabstop=4
" 输入和退格时 1 tab 等于 4 space
set softtabstop=4

" 禁用自动换行
"set wrap
set nowrap
" 自动换行时，禁用断词保护
set nolinebreak

" 闪烁显示匹配的括号
set showmatch
" 括号匹配闪烁停留的时间（单位是十分之一秒）
set matchtime=1

" 启用代码折叠（但是手动）
set foldenable
set foldmethod=manual

" 启用拼写检查
set spell

""" 搜索相关
"""

" 搜索时忽略大小写，但输入大写字母后保持敏感
set ignorecase smartcase
" 高亮搜索结果
set hlsearch
" 即时显示搜索结果
set incsearch
" 循环搜索结果
set wrapscan

