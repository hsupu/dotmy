<#
.NOTES
FastGitORG 于 240607 跑路 https://github.com/FastGitORG/www/blob/rm/index.cn.html

.NOTES
可以通过如下方法透明替换链接
git config --global url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"
git config protocol.https.allow always
#>
param(
    [switch]$UseGhProxy,
    # [switch]$UseFastGit,
    [switch]$UseToolwa,
    [switch]$UseGitCloneCom,
    [switch]$NoInstall,
    [switch]$SetMirror,
    [switch]$AddBuckets
)

$ErrorActionPreference = 'Stop'
trap {
    throw "$($_.ToString())`n$($_.ScriptStackTrace)"
}

# scoop
if (-not (Test-Path -LiteralPath env:SCOOP)) {
    $env:SCOOP = "C:\opt\scoop"
    [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
}

if (Test-Path -LiteralPath env:SCOOP_PROXY) {
    $proxy = $env:SCOOP_PROXY
}
else {
    $proxy = $null
}

# 权限放行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

$RewriteInstallScript = $false
if ($UseGhProxy) {
    $InstallScript = "https://mirror.ghproxy.com/raw.githubusercontent.com/lzwme/scoop-proxy-cn/master/install.ps1"
    $RewriteInstallScript = $true
    $Mirror = "https://mirror.ghproxy.com/github.com"
}
# elseif ($UseFastGit) {
#     $InstallScript = "https://raw.fastgit.org/scoopinstaller/install/master/install.ps1"
#     $RewriteInstallScript = $true
#     $Mirror = "https://download.fastgit.org"
# }
elseif ($UseToolwa) {
    $InstallScript = "https://toolwa.com/github/toolwa/scoop/master/install.ps1"
    $RewriteInstallScript = $true
    $Mirror = "https://toolwa.com/github"
}
elseif ($UseGitCloneCom) {
    $InstallScript = "https://gitclone.com/github.com/lukesampson/scoop/master/install.ps1"
    $RewriteInstallScript = $true
    $Mirror = "https://gitclone.com/github.com"
}
else {
    $InstallScript = "get.scoop.sh"
    $Mirror = "https://github.com"
}

if (-not $NoInstall) {
    $script = Invoke-RestMethod $InstallScript
    if ($RewriteInstallScript) {
        $script = $script.Replace('https://github.com/ScoopInstaller/', "$Mirror/ScoopInstaller/")
    }
    # Write-Host $script
    &{ Invoke-Expression $script }
}

# so far, scoop only accept HTTP proxy
# scoop config proxy 127.0.0.1:4000

# 不打印 git commit diff
& scoop config show_update_log false

try {
    Set-Item -ErrorAction Stop -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
}
catch {
    New-Item -ErrorAction Stop -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
}

# 使用 winget 管理 7zip
# & winget install --source winget 7zip.7zip
# & scoop config use_external_7zip true
# & scoop config 7ZIPEXTRACT_USE_EXTERNAL true
# & scoop config 7ZIPEXTRACT_EXTERNAL_PATH "C:\Program Files\7-Zip\7z.exe"

# 使用 scoop 管理 7zip
& scoop install 7zip git

# alternative for unpacking MSI files
& scoop install lessmsi
# & scoop config use_lessmsi true
# & scoop config MSIEXTRACT_USE_LESSMSI true

# 'Inno Setup Unpacker' is required for unpacking InnoSetup files
& scoop install innounp

# One of them. Required for unpacking installers created with the WiX Toolset
# & scoop install dark
# & scoop install wixtoolset

# & scoop install aria2
# & scoop config aria2-enabled true

& scoop bucket known

& scoop config SCOOP_REPO
& scoop config SCOOP_REPO "$mirror/ScoopInstaller/Scoop"

if ($SetMirror) {
    & scoop bucket rm main
    & scoop bucket add main "$mirror/ScoopInstaller/Main"

    & scoop bucket rm extras
    & scoop bucket add extras "$mirror/ScoopInstaller/Extras"

    & scoop bucket rm java
    & scoop bucket add java "$mirror/ScoopInstaller/Java"

    # & scoop bucket rm portablesoft
    # & scoop bucket add portablesoft "$mirror/shenbo/portablesoft"

    & scoop bucket rm scoopcn
    & scoop bucket add scoopcn "$mirror/scoopcn/scoopcn"
}

if ($AddBuckets) {
    # & scoop bucket rm games
    # & scoop bucket add games "$mirror/ScoopInstaller/Games"

    & scoop bucket rm java
    & scoop bucket add java "$mirror/ScoopInstaller/Java"

    # & scoop bucket rm nirsoft
    # & scoop bucket add nirsoft "$mirror/ScoopInstaller/Nirsoft"

    & scoop bucket rm nonportable
    & scoop bucket add nonportable "$mirror/ScoopInstaller/Nonportable"

    # & scoop bucket rm versions
    # & scoop bucket add versions "$mirror/ScoopInstaller/Versions"

    # 更适合中国宝宝的聚合仓库
    # 用法：scoop install spc/<app>
    & scoop bucket rm spc
    & scoop bucket add spc "$mirror/lzwme/scoop-proxy-cn"

    # & scoop bucket rm Ash258
    # & scoop bucket add Ash258 "$mirror/Ash258/Scoop-Ash258"

    # & scoop bucket rm dorado
    # & scoop bucket add dorado "$mirror/chawyehsu/dorado"

    # & scoop bucket rm spoon
    # & scoop bucket add spoon "$mirror/FDUZS/spoon"
}

Write-Host @"
Tips
    # 官方 scoop search 基于 PowerShell，效率很低，使用 golang 编写的替代品
    scoop install scoop-search
    # 用法：scoop-search <keyword>

    # Hash Check Failed 会出现在那些配置了 hash 检查但链接却动态更新的软件包上，可以使用 -s 跳过检查
    # 用法：scoop install -s <app>

    # 问题排查
    scoop checkup

    # 重置所有包
    scoop reset *
"@
