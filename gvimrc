
if !has('gui_running')
    echom "Not running in a GUI env"
endif

source <sfile>:h/vimrc

" 抗锯齿
set antialias

" 默认配色方案 MacVim
if !exists("macvim_skip_colorscheme") && !exists("colors_name")
    colorscheme macvim
endif
