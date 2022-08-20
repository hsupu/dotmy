# 个人 VIM 配置方案

目标是使 vim 简单可用，终端生活便利一些，而非什么大而全的 CLI IDE。毕竟，有 GUI 的话，vscode 更好用。

## 使用

在每台新机器上，运行 `install.sh` 描述的每一步。

插件管理器是 [vim-plug](https://github.com/junegunn/vim-plug)，  
插件列表在 `plugins.vim` 里，它们会被装入 `plugged/` 目录。

- `:PlugUpgrade` 命令更新 vim-plug
- `:PlugUpdate` 命令更新其他插件
- `:PlugClean` 命令清理已经从列表中除去的插件

配色方案需要放在 `colors/` 里，但也要在插件列表里从而能够跟随上游更新。  
因此，每次加入新配色方案时需要手动软链接。  
记得把命令写进 `link-colors.sh`，便于下次操作。

## 目录结构

配置文件：

- vimrc
- editor.vim    编辑区配置
- file.vim      文件相关配置
- gvimrc        GUI 配置
- status.vim    状态栏配置
- term.vim      终端交互配置
- plugins.vim   插件列表
- vimrc.custom  不在版本控制内的配置

其他：

- autoload/     会被自动加载的模块，目前只有 VimPlug
- colors/       软链接的配色方案
- plugged/      已安装的插件，受 VimPlug 管理

## 参考

- http://vimdoc.sourceforge.net/htmldoc/starting.html#vimrc
- https://vimhelp.org
- https://vimtricks.com
