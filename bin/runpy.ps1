<#
.SYNOPSIS
& runpy.ps1 <venv> <args...>

.NOTES
需要准备 $env:DOTMY/local/rt-py$venv.txt
#>
param()

$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/langex.ps1")

$venv = $args[0]
$flattenedArgs = @($args[1..($args.Length-1)] | Flatten-Array)
# $flattenedArgs

if ($venv -ieq "default") {
    $pathFile = Join-Path $env:DOTMY "local/rt-py.txt"
}
else {
    $pathFile = Join-Path $env:DOTMY "local/rt-py$venv.txt"
}

$rtRoot = (Get-Content -ErrorAction Stop -LiteralPath $pathFile -Raw -Encoding utf8).Trim()
$rtRoot = Resolve-Path -ErrorAction Stop -LiteralPath $rtRoot

$quotedArgs = $flattenedArgs | Quote-Arg
# $quotedArgs
$cmd = ". `"$(Join-Path $rtRoot "Scripts/activate.ps1")`"; & $quotedArgs"
# $cmd

$base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cmd))
& powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand $base64
if ($LASTEXITCODE -ne 0) {
    throw "powershell.exe exit code $LASTEXITCODE"
}
