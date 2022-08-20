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
├── zshrc.sh        -> $HOME/.zshrc
├── zlogin.sh       -> $HOME/.zlogin
└── zlogout.sh      -> $HOME/.zlogout
```

### 加载细节

`zshrc` 依次导入：

- `$HOME/.config/shell/env.sh`
- `$HOME/.config/shell/pre.sh`
- `$HOME/.config/shell/pre-zsh.sh`
- `$HOME/.config/shell/pre-omz.sh`
- `$ZSH/oh-my-zsh.sh`
- `${SHRC_DIR}/aliases.sh`
- `$HOME/.config/shell/post.sh`
- `$HOME/.config/shell/post-zsh.sh`
- `$HOME/.config/shell/post-omz.sh`
