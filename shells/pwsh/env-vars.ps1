
# $env:HOME = $env:USERPROFILE

if (-not (Test-Path -LiteralPath env:USER)) {
    # whoami 有可能卡住
    # $env:USER = $(whoami)
    $env:USER = "$env:USERDOMAIN\$env:USERNAME"
}

$isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0
$env:SHELL = if ($isPwsh) { "pwsh" } else { "powershell" }

if (Test-Path -LiteralPath env:SHLVL) {
    $env:SHLVL = [int]$env:SHLVL + 1
}
else {
    $env:SHLVL = 1
}

function Set-Environment() {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Key,
        [Parameter(Mandatory, Position=1)]
        [string]$Value,
        [switch]$UserScope
    )
    if (Test-Path -LiteralPath "env:$Key") {
        $existed = Get-Item -LiteralPath "env:$Key"
        if ($Value -ne $existed) {
            Set-Item -LiteralPath "env:$Key" -Value $Value | Out-Null
        }
    }
    else {
        New-Item -Path "env:$Key" -Value $Value | Out-Null
    }

    if ($UserScope) {
        $existed = [System.Environment]::GetEnvironmentVariable($Key, [System.EnvironmentVariableTarget]::User);
        if ($Value -ne $existed) {
            Write-Host "Override UserEnv $Key ($existed => $Value)"
            [System.Environment]::SetEnvironmentVariable($Key, $Value, [System.EnvironmentVariableTarget]::User);
        }
    }
}

$dotmy = (Get-Item $PSScriptRoot).Parent.Parent
if ([string]::IsNullOrEmpty($dotmy.LinkType)) {
    $dotmy = $dotmy.FullName
}
else {
    $dotmy = $dotmy.Target
}
Set-Environment -Key "DOTMY" -Value $dotmy -UserScope
