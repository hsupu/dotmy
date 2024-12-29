# 目录结构

本仓库定义的目录结构：

```
C:\my\                      个人根目录
    bin\ -> $env:DOTMY\bin\
    local\                  本地
        app\
        cli\
        manuals\
        opt\
            scoop\
            vcpkg\
        portable\
        srv\
        svc\ -> srv\
        var\
            dotmy\          本仓库
            MyUbuntu\       WSL
    spec\
        NUL                 空文件
        NULD\               空文件夹
    t\                      临时文件根目录
    ws\                     开发工作的根目录
        GitHub\<class>\

C:\msys64\

C:\Users\xp\
    .config\
    .local\
        bin\
        share\
    Documents\PowerShell\Sync\ -> $env:DOTMY\
```

自定义的其他软件路径：

```
C:\msys64\

C:\Sandbox\
C:\Sandboxied\
    app\
    dl\
    var\

C:\Users\xp\
    source\ -> C:\my\ws\vs\
```

一些软件、工具的默认路径：

```
C:\ProgramData\

C:\Program Files\
C:\Program Files (x86)\

C:\Users\xp\
    .ssh\
    AppData\
        Local\
            GitHubDesktop\
            JetBrains\
            pnpm\                       @pnpm/exe
            Programs\
                Microsoft VS Code\
        Roaming\
            Caddy\
            Code\
    Desktop\
    Downloads\
```
