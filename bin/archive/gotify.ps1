param(
    [switch]$Detach,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Remaining
)

$exeName = "gotify-windows-amd64.exe"
$dirHint = "C:\my\local\services\gotify"

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
    Start-Process ".\$exeName" -ArgumentList $Remaining `
        -Wait:$(-not $Detach) -NoNewWindow:$(-not $Detach)
}
finally {
    # [Console]::TreatControlCAsInput = $false
    Pop-Location
}
