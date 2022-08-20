# pipenv

[pipenv][pipenv] 是一个组合使用 pip + virtualenv 的命令集。

pipenv 能够像 npm `packages.lock` 一样得到一份精确的依赖包版本信息，从而使开发和部署更为一致。

## 安装

```bash
pip install --user pipenv
```

## 配置

配置是针对特定项目的，位于项目根目录的 `Pipfile` 文件。

```toml
[[source]]
name = "tsinghua"
url = "https://pypi.tuna.tsinghua.edu.cn/simple"
verify_ssl = true

[requires]
# pipenv rejects to impl checking specific sub-versions
python_version = "3"

[packages]

[dev-packages]
pytest = "*"
```

## 使用

```bash
# install from "Pipfile"
pipenv install
# add a package (into virtualenv)
pipenv install <pkg>
# activate virtualenv
pipenv shell
# list outdated pkgs
pipenv update --outdated
# upgrade a pkg
pipenv update <pkg>
```

## 参考

- [pipenv][pipenv]

[pipenv]: https://pipenv.pypa.io/en/latest/
