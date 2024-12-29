param(
    [Parameter(Mandatory, Position=0)]
    [string]$Name,

    [Parameter(Mandatory, Position=1)]
    [string]$Path,

    [switch]$Shim,
    [switch]$Lnk,
    [switch]$Ps1,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Remaining
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$GenDirPath = "C:\my\local\gen\bin"

$Name = $Name.Trim()
if ($Name.EndsWith('.shim')) {
    $Name = $Name.Substring(0, $Name.Length - 5)
    $Shim = $true
}
if ($Name.EndsWith('.exe')) {
    $Name = $Name.Substring(0, $Name.Length - 4)
    $Shim = $true
}
elseif ($Name.EndsWith('.lnk')) {
    $Name = $Name.Substring(0, $Name.Length - 4)
    $Lnk = $true
}
elseif ($Name.EndsWith('.ps1')) {
    $Name = $Name.Substring(0, $Name.Length - 4)
    $Ps1 = $true
}

if (-not ($Shim -or $Lnk -or $Ps1)) {
    $Ps1 = $true
}

. "$PSScriptRoot\funcs.ps1"

if ($Shim) {
    Add-Shim -DirPath $GenDirPath -Name $Name -TargetPath $Path @Remaining
    exit(0)
}

if ($Lnk) {
    Add-Shortcut -DirPath $GenDirPath -Name $Name -TargetPath $Path @Remaining
    exit(0)
}

if ($Ps1) {
    Add-Ps1 -DirPath $GenDirPath -Name $Name -TargetPath $Path @Remaining
    exit(0)
}

Write-Error "Must specify one of { -Shim -Lnk -Ps1 }"
exit(1)
