
function Add-Shim() {
    param(
        [string]$DirPath,
        [string]$Name,
        [string]$TargetPath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
    Copy-Item (Join-Path $PSScriptRoot "shim-v2.exe") (Join-Path $DirPath "$Name.exe")
    Set-Content -Path (Join-Path $DirPath "$Name.shim") -Value @"
path = $TargetPath
args = $Remaining
"@
}

function Add-Shortcut() {
    param(
        [string]$DirPath,
        [string]$Name,
        [string]$TargetPath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
    Write-Error "NOTIMPL"
}

function Add-Ps1() {
    param(
        [string]$DirPath,
        [string]$Name,
        [string]$TargetPath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
    Set-Content -Path (Join-Path $DirPath "$Name.ps1") -Value @"
# [Console]::TreatControlCAsInput = `$true
& `"$TargetPath`" $Remaining @args
"@
}

function Add-Cmd() {
    param(
        [string]$DirPath,
        [string]$Name,
        [string]$TargetPath,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Remaining
    )
    Set-Content -Path (Join-Path $DirPath "$Name.cmd") -Value @"
`"$TargetPath`" $Remaining %*
"@
}
