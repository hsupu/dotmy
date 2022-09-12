param(
    [Parameter(Position=0)]
    [string]$Alias,

    [switch]$Detach,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Remaining
)

if ([string]::IsNullOrEmpty($Alias)) {
    $Alias = "co4"
}
else {
    $Alias = $Alias.Trim()
}

if (-not (Test-Path env:MYHOME_SRV)) {
    $env:MYHOME_SRV = "C:\my\local\srv"
}

$exeArgs = @("-c", "frpc.$Alias.ini") + $Remaining

$exeName = "frpc.exe"
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
