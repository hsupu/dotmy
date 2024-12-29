param(
    [Parameter(Mandatory, Position=0)]
    [string]$Path
)

trap {
    throw "$_`n$($_.ScriptStackTrace)"
}

$src = Resolve-Path $Path

$dir = Join-Path $env:LOCALAPPDATA "StartAllBack"
if (-not (Test-Path $dir)) {
    throw "DirNotFound: $dir"
}

$dst = Join-Path $dir "StartAllBackX64.dll"
if (-not (Test-Path $dst)) {
    throw "DllNotFound: $dst"
}

$proc = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
if ($null -ne $proc) {
    $proc | Stop-Process -ErrorAction Continue
    Start-Sleep -Seconds 1
}

$dstBlk = "$($dst).bak"
if (Test-Path $dstBlk) {
    Remove-Item -Path $dstBlk -Force
}
Move-Item -Path $dst -Destination $dstBlk

Copy-Item -Path $src -Destination $dst

$proc = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
if ($null -eq $proc) {
    & explorer.exe
}
