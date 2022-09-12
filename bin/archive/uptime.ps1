param(
    [int]$Port,

    [switch]$Detach
)

if (0 -eq $Port) {
    $Port = 5003
}

$env:UPTIME_KUMA_PORT = $Port

$exeName = "server\server.js"
$dirHint = "C:\my\local\services\uptime-kuma-lite"

if (Test-Path "$PWD\$exeName") {
    $dir = $PWD
}
elseif (Test-Path "$PSScriptRoot\$exeName") {
    $dir = $PSScriptRoot
}
elseif (Test-Path "$dirHint\$exeName") {
    $dir = $dirHint
}

Push-Location $dir
# [Console]::TreatControlCAsInput = $true
try {
    Start-Process node $exeName `
        -Wait:$(-not $Detach) -NoNewWindow:$(-not $Detach)
}
finally {
    # [Console]::TreatControlCAsInput = $false
    Pop-Location
}
