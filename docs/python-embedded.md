
下载解压 `python-3.12.8-embed-amd64.zip`

```ps1
$env:PATH = "C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\"

wget https://bootstrap.pypa.io/get-pip.py
.\python.exe .\get-pip.py
```

修改 `python12._pth` 使之（按顺序）包含如下几行

```
python312.zip
DLLs
Lib
.
Lib/site-packages
```

通过 `.\python.exe -m site` 确认生效

复制其他发行版/源码仓库中的 `Lib/venv` 到嵌入版目录，可以直接使用该模块 `.\python.exe -m venv`。
