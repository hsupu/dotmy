
$exe = Join-Path $(scoop prefix git) "usr\bin\mintty.exe"
$exeArgs = @("-o", "AppID=GitForWindows.Bash", "--window", "min", "/usr/bin/bash", "--login", "-i")
Start-Process -FilePath $exe -ArgumentList $exeArgs -NoNewWindow
