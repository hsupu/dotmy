
## PowerShell

- https://learn.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-keys?view=powershell-7.3
- https://learn.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-entries?view=powershell-7.3

Registry Provider 全称是 `Microsoft.PowerShell.Core\Registry` 短名是 `Registry`。它也注册了多个根别名如 `HKCU` `HKLM`。

这几者指向同一个路径：

- `Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER`
- `Registry::HKEY_CURRENT_USER`
- `Registry::HKCU`
- `HKCU`

### 处理项

```ps1
# 增
New-Item -Path 'HKCU:\Software_DeleteMe'
# 删
Remove-Item -Path 'HKCU:\Software_DeleteMe' -Recurse

# 复制
Copy-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -Destination HKCU: -Recurse
# 移动
Move-Item ?
# 改名
Rename-Item ?

# 列表
Get-ChildItem -Path 'HKCU:\' | Select-Object Name

# 存在判断
Test-Path ?

# 访问
[Microsoft.Win32.RegistryKey]$regKey = Get-Item -Path 'HKCU:\'
```

### 处理键值

```ps1
# 增
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name PowerShellPath -PropertyType String -Value $PSHome
# 删
Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name PSHome

# 复制
Copy-ItemProperty ?
# 移动
Move-ItemProperty ?
# 改名
Rename-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name PowerShellPath -NewName PSHome

# 改值
Set-ItemProperty -Path HKCU:\Environment -Name Path -Value $NewPath

# 列表
Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion | Select-Object -ExpandProperty Property

# 存在判断

# 查值
# 新写法
$path = Get-ItemPropertyValue -Path HKCU:\Environment -Name Path
# 旧写法
# PropertyName "Path" 成为返回的 PSCustomObject 对象的 Property "Path"
$ret = Get-ItemProperty -Path HKCU:\Environment -Name Path
$path = $ret.Path
```

### 借助第三方

```ps1
$wsh = (New-Object -ComObject WScript.Shell)
$wsh.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DevicePath")
```

## reg.exe

```bat
> reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion /v DevicePath

! REG.EXE VERSION 3.0

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion
    DevicePath  REG_EXPAND_SZ   %SystemRoot%\inf
```
