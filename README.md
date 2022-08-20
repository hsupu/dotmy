# \.my

个人开发环境配置。

## 思路与结构

经过实践，本仓库主要有以下考虑：

- 一个人惯用的用户级配置通常不随设备而转移，适合置于一个仓库内
- 兼顾 Windows/Linux/Mac
    - 文件路径格式、惯用目录、执行权限、系统工具皆有不同
    - 额外地，Windows 要考虑 msys2；Linux 也要考虑 WSL
- 不保存二进制文件，目前也无如此需求
- 提交历史几乎无用（因此可以合并提交记录）
- 独立分支用于较为独立的模块
- 敏感信息另起仓库

分支：

- main
- win/pwsh - PowerShell.UserProfile + `C:\My\Bin`
- vim

main 分支：

- homebin
- notes
- profiles
- programs
- shells
- symlinker
