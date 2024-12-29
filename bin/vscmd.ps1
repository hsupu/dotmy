<#
.SYNOPSIS
定位并打开 Developer Command Prompt for Visual Studio

.NOTES
241110
#>
[CmdletBinding(PositionalBinding=$false)]
param(
    # imply NewWindow=true
    [Parameter(Mandatory=$false)]
    [string]$UIHost,

    # imply NewWindow=true UIHost="conhost.exe"
    [switch]$UseConHost,

    # imply NewWindow=true UIHost="wt.exe"
    [switch]$UseWT,

    # detach from current console
    [switch]$NewWindow,

    [Parameter(ValueFromRemainingArguments)]
    [AllowEmptyCollection()]
    $Remaining
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

[string]$vsroot = & vsroot
if ([string]::IsNullOrEmpty($vsroot)) {
    exit(1)
}
Write-Host "VSROOT = $vsroot"

if ($UseConHost) {
    $UIHost = "conhost.exe"
}
elseif ($UseWT) {
    $UIHost = "wt.exe"
}
Write-Host "UIHost = $UIHost"

# /A : output ANSI
# /S : don't preserve quote characters
# /K : keep cmd.exe after command exits
$cmdArgs = @(
    "/A", "/S",
    "/K", "@", "`"$vsroot\Common7\Tools\VsDevCmd.bat`"",
    "-startdir=none",
    "-arch=x64",
    "-host_arch=x64"
) + $Remaining

if (-not [string]::IsNullOrEmpty($UIHost)) {
    & $UIHost $env:ComSpec @cmdArgs
    return
}

if ($NewWindow) {
    Start-Process -FilePath $env:ComSpec -ArgumentList $cmdArgs
}
else {
    & $env:ComSpec @cmdArgs
}
