param(
    [string]$Address,
    [int]$Port,

    [string]$Root
)

if ([string]::IsNullOrEmpty($Address)) {
    $Address = "127.0.0.1"
}

if (0 -eq $Port) {
    $Port = 2335
}

if ([string]::IsNullOrEmpty($Root)) {
    $Root = "C:\my\local\media"
}

if (-not (Test-Path env:MYHOME_SRV)) {
    $env:MYHOME_SRV = "C:\my\local\srv"
}

$exeName = "filebrowser.exe"
$dirHint = "${env:MYHOME_SRV}\filebrowser"

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
try {
    & “.\$exeName" -a $Address -p $Port -r $Root
}
finally {
    Pop-Location
}
