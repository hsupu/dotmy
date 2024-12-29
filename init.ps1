<#
.DESCRIPTION
- mklink /d C:\my\bin "$PSScriptRoot\bin"
- git clone dotmy-profiles "$PSScriptRoot\private"
#>
param()

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$env:DOTMY = $PSScriptRoot
[Environment]::SetEnvironmentVariable('DOTMY', $env:DOTMY, 'User')

mkdir -p "C:\my\local" -ErrorAction SilentlyContinue
if (-not (Test-Path -LiteralPath "C:\my\bin")) {
    & cmd /c mklink /d "C:\my\bin" "$PSScriptRoot\bin"
}
if (-not (Test-Path -LiteralPath "$HOME\.local")) {
    & cmd /c mklink /d "$HOME\.local" "C:\my\local"
}
else {
    Write-Warning -WarningAction Continue "$HOME\.local exists, please move and link it manually"
}

& "$PSScriptRoot\profiles\set-current.ps1"

if (-not (Test-Path -LiteralPath "$PSScriptRoot\private")) {
    if (Test-Path (Join-Path $HOME ".ssh/config")) {
        $privateRepoUrl = "git@gitee.com:hsupu/dotmy-profiles.git"
    }
    else {
        $privateRepoUrl = "https://gitee.com/hsupu/dotmy-profiles.git"
    }
    & git clone --single-branch --branch $(git branch --show-current) $privateRepoUrl "$PSScriptRoot\private"
}
& "$PSScriptRoot\private\set-current.ps1"


mkdir -p "$HOME\.config\git" -ErrorAction SilentlyContinue
if (-not (Test-Path -LiteralPath "$HOME\.config\git\config")) {
    Copy-Item "$PSScriptRoot\programs\git\config" "$HOME\.config\git\config"
    & notepad "$HOME\.config\git\config"
}
else {
    Write-Warning -WarningAction Continue "$HOME\.config\git\config exists, please modify it manually"
}
