param(
    [string]$Alias,

    [switch]$Detach
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if ([string]::IsNullOrEmpty($Alias)) {
    $Alias = "az1"
}
else {
    $Alias = $Alias.Trim()
}

if (-not (Test-Path env:MYHOME_SRV)) {
    $env:MYHOME_SRV = "C:\my\local\srv"
}

$exeArgs = @("-c", "frpc.$Alias.ini") + $args

$exeName = ".\frpc.exe"
$dirHint = "${env:MYHOME_SRV}\frp"

if (Test-Path "$PWD\$exeName") {
    $dir = $PWD
}
elseif (Test-Path "$PSScriptRoot\$exeName") {
    $dir = $PSScriptRoot
}
elseif (Test-Path "$dirHint\$exeName") {
    $dir = $dirHint
}
else {
    Write-Error "`$dir not found"
}

Push-Location $dir
# [Console]::TreatControlCAsInput = $true
try {
    Start-Process $exeName -ArgumentList $exeArgs `
        -Wait:$(-not $Detach) -NoNewWindow:$(-not $Detach)
}
finally {
    # [Console]::TreatControlCAsInput = $false
    Pop-Location
}
