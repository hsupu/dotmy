# pipx

[pipx][pipx] 是一个 Python 软件包辅助脚本，能够为其创建一个隔离环境并运行它。

适合于想用 Python 软件包，但又不想与当前环境的 Python 共享软件包依赖的情形。如使用 `ansible` `virtualenv`。

## 安装

```bash
sudo apt install python3-venv
python -m pip install --user pipx
python -m pipx ensurepath
```

## 使用

```bash
pipx list
pipx install <pkg>
pipx upgrade <pkg>
pipx uninstall <pkg>

pipx run <pkg> <args>
```

## 参考

- [pipx][pipx]

[pipx]: https://github.com/pypa/pipx
