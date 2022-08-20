" 版本检查
if v:version < 703
    echo '.vimrc requires Vim 7.3 or greater'
    finish
endif
" 关闭兼容模式。这也会修改其他设置，所以置于最前
set nocompatible

" let mapleader = ","
let $LANG = 'en_US.UTF-8'
let &langmenu = $LANG

" 不显示首页提示
set shortmess=atI

source <sfile>:h/file.vim
source <sfile>:h/editor.vim
source <sfile>:h/status.vim
source <sfile>:h/term.vim

" 加载 vim-plug
" https://github.com/junegunn/vim-plug
let s:vimplug_dir = expand("<sfile>:h") . "/plugged"
call plug#begin(s:vimplug_dir)

source <sfile>:h/plugins.vim

" 应用 vim-plug
call plug#end()

" 配色高亮方案
colorscheme molokai

let s:vimrc_custom = $HOME . "/.vim/vimrc.custom"
if filereadable(expand(s:vimrc_custom))
    "echo "source " . s:vimrc_custom
    exec "source " . s:vimrc_custom
endif
