# 壳程序们的配置

目前包括 bash zsh 两种方案，支持 Mac/Linux/WSL/msys2 四种环境。（差生文具多

## 设计思路

定义两个环境变量：

```
$DOTMY      => 本仓库 main 分支根目录
$SHRC_DIR   => 特定 shell 配置根目录（如 $DOTMY/shells/bash）
```

每台机器的独特配置，参见 `$DOTMY/profiles/<name>/`。共用的部分则移至此处。
