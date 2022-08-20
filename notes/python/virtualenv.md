# virtualenv

```bash
# 只在第一次需要
python -m pip install virtualenv

# 在当前目录创建隔离环境 venv
python -m virtualenv venv
# 进入隔离环境
. venv/bin/activate
```

Windows with [pwsh][pwsh]

[pwsh]: https://aka.ms/powershell

```ps1
# 只在第一次需要
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

. ./venv/Scripts/Activate.ps1
```
