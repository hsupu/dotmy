# \.my for \*nix

## 本分支的项目结构

配置

- remap.py - 配置引擎，会解析 mapping.py，按需对各种文件（夹）做符号链接
- overrides - 可复用的某类配置
- private - 敏感信息配置，另一私有仓库
- profiles - 各机器的配置
- profiles/current - 符号链接，指向当前机器的配置目录
- programs  - 各程序的配置
- shells - 各 Shell 的配置

脚本

- homebin - 会被添入 PATH 路径的目录，放置常用趁手的脚本
- scripts - 偶用、有留存复用价值的脚本
- snippets - 不能直接使用，需要二次编写的代码片段

其他

- notes - 备忘，参见其中 README.md
