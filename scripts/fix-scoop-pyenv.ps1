<#
.NOTES
根据这篇文章的说法，msiexec 为了解决 CVE-2023-21800 引入了 Redirection Guard 的概念，会验证 junction creator 是否为管理员组。
https://blog.doyensec.com/2023/03/21/windows-installer.html#redirection-guard

简单尝试，本脚本的方法无效，只使用 icacls 修改 owner 是不行的。似乎目录 owner 并未改变。
#>
param(
    [switch]$Tricky
)

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

sudo scoop reset pyenv
return

function fix([IO.FileSystemInfo]$fi, [string]$target) {
    if ($Tricky) {
        # 可行的法子
        Remove-Item -LiteralPath $fi.FullName
        if ('' -eq $target) {
            $target = (Join-Path $env:SCOOP "persist\pyenv\pyenv-win" $fi.Name)
        }
        & cmd /c mklink /j $fi.FullName $target
        return
    }

    & icacls $fi.FullName /L /setowner BUILTIN\Administrators
    $fi.Attributes -= 'ReadOnly'
}

pushd (Join-Path $env:SCOOP "apps\pyenv")
try {
    fix (Get-Item -ErrorAction Stop .\current) "3.1.1"

    cd "current\pyenv-win"
    fix (Get-Item -ErrorAction Stop .\install_cache)
    fix (Get-Item -ErrorAction Stop .\shims)
    fix (Get-Item -ErrorAction Stop .\versions)
}
finally {
    popd
}
