
set encoding=utf-8
" 打开文件时尝试使用的编码列表，fileencodings 的别名
" 不设置则使用当前 locale
set fencs=utf-8,ucs-bom,gb18030

" 探测文件类型
filetype on
" 探测缩进类型
filetype indent on
" 开启文件类型相关的扩展
filetype plugin on
filetype plugin indent on

" 禁用文件备份
set nobackup
set nowritebackup
"set backupext=.bak

" 不强制写入刷新（交由操作系统管理）
set nofsync
" 禁用文件更新探测
set noautoread

" 禁用自动保存（切换文件时）
set noautowrite
" 启动多文件的修改缓冲区（避免在切换文件时因未保存而报错）
set hidden

" see :help swap-file
" 生成交换文件，允许意外退出时恢复编辑中的内容
set swapfile
" 每 10s / 400lines 保存一次
set updatetime=10000
set updatecount=400
