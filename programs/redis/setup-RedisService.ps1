<#
.NOTES
使用 https://github.com/redis-windows/redis-windows 产生的 MSYS2 版本
作者说，由于 MSYS2 的限制，程序本身必须置于至少二层目录下，如 C:\Software\Redis\redis-server.exe ，否则无法正确解析路径。但经我实验似乎不需要。

.NOTES
曾经，MSOpenTech 构建的 v3 及其后续 https://github.com/tporadowski/redis v5 都是使用 redis-server --service-install 安装服务，现在不支持了。
#>
param(
)

$RedisService = (Get-Command -ErrorAction Stop "RedisService").Path
$ServiceName = "Redis"

function ConvertTo-CygwinPath {
    param(
        [string]$Path
    )
    if ($Path -match "^([a-z]):\\") {
        # MSYS2 支持 /cygdrive/c\path\to\file 的混合格式
        $Path = "/cygdrive/$($matches[1])$($Path.Substring(2))"
    }
    return $Path
}

function ConvertFrom-CygwinPath {
    param(
        [string]$Path
    )
    if ($Path -match "^/cygdrive/([a-z])[\\/](.*)") {
        $Path = "$($matches[1]):\$($matches[2])"
    }
    return $Path
}

Push-Location $PSScriptRoot
try {
    $conf = Resolve-Path -ErrorAction Stop -LiteralPath ".\redis.windows.conf"
    $conf = ConvertTo-CygwinPath -Path $conf

    & sc.exe create $ServiceName binpath= "$RedisService -c $conf" start= disabled
    if (0 -ne $LASTEXITCODE) {
        throw "sc.exe exited with code $LASTEXITCODE"
    }
    Get-Service -ErrorAction Stop $ServiceName | Set-Service -ErrorAction Stop -StartupType Manual
}
finally {
    Pop-Location
}
