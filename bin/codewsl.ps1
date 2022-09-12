param(
    [string]$Distro
)

$exe = $(which code.cmd)
if ([string]::IsNullOrEmpty($exe)) {
    Write-Error "`"code`" not found"
    exit(1)
}

Write-Host $exe
$exeArgs = @("-e", $exe)
if (-not ([string]::IsNullOrEmpty($Distro))) {
    $exeArgs += @("-d", $Distro)
}

& wsl @exeArgs -- @args
