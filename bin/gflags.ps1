param(
    [string]$Exe,
    [switch]$Disable
)

if ([string]::IsNullOrEmpty($Exe)) {
    $Exe = "cppunitstub.exe"
}

if ($Disable) {
    & gflags -p /disable "`"$Exe`""
}
else {
    & gflags -p /enable "`"$Exe`"" /debug vsjitdebugger.exe
}
