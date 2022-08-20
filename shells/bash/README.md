# my bash

## 启用方式

软链接 `$DOTMY/profiles/<hostname>` => `$HOME/.config/shell`

运行 `install.sh`

## 项目结构

定义了环境变量：

```bash
SHRC_DIR=$DOTMY/shells/bash/
```

入口文件：

```bash
${SHRC_DIR}
├── bashrc.sh       -> $HOME/.bashrc
├── login.sh        -> $HOME/.bash_login
├── logout.sh       -> $HOME/.bash_logout
└── profile.sh      -> $HOME/.bash_profile
```

### 加载细节

login shell 入口是 `.bash_profile`，non-login shell 入口是 `.bashrc`。`profile` 导入 `bashrc`，`bashrc` 仅在交互环境下生效。

`bashrc` 依次导入：

- `$HOME/.config/shell/env.sh`
- `$HOME/.config/shell/pre.sh`
- `$HOME/.config/shell/pre-bash.sh`
- `${SHRC_DIR}/commands.sh`
- `${SHRC_DIR}/extra.sh`
- `${SHRC_DIR}/prompt.sh`
- `$HOME/.config/shell/post.sh`
- `$HOME/.config/shell/post-bash.sh`
- `bash_completion`

通常，`$HOME/.config/shell/` 是指向 `$DOTMY/profiles/<hostname>/` 的目录符号链接。
