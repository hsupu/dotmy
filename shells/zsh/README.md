# my zsh

## 安装和启用

软链接 `$DOTMY/profiles/<name>` => `$HOME/.config/shell`

参考 `init.sh`

## 项目结构

定义了环境变量：

```zsh
SHRC_DIR=$DOTMY/shells/zsh/
```

入口文件：

```zsh
${SHRC_DIR}
├── zprofile.sh     -> $HOME/.zprofile
├── zshenv.sh       -> $HOME/.zshenv
├── zshrc.sh        -> $HOME/.zshrc
├── zlogin.sh       -> $HOME/.zlogin
└── zlogout.sh      -> $HOME/.zlogout
```

### 加载细节

官方 [zsh 依次导入](https://zsh.sourceforge.io/Doc/Release/Files.html)：

- `/etc/zshenv` → `$ZDOTDIR/.zshenv`
- if a login shell: `/etc/zprofile` → `$ZDOTDIR/.zprofile`
- if interactive: `/etc/zshrc` → `$ZDOTDIR/.zshrc`
- if a login shell: `/etc/zlogin` → `$ZDOTDIR/.zlogin`

我的 `zshrc` 依次导入：

- `$HOME/.config/shell/env.sh`
- `$HOME/.config/shell/pre.sh`
- `$HOME/.config/shell/pre-zsh.sh`
- `$HOME/.config/shell/pre-omz.sh`
- `$ZSH/oh-my-zsh.sh`
- `${SHRC_DIR}/aliases.sh`
- `$HOME/.config/shell/post.sh`
- `$HOME/.config/shell/post-zsh.sh`
- `$HOME/.config/shell/post-omz.sh`

通常，`$HOME/.config/shell/` 是指向 `$DOTMY/profiles/<hostname>/` 的目录符号链接。
