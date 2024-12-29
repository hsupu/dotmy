<#
.SYNOPSIS
增删杀毒扫描的例外项

.EXAMPLE
Add-MpExemption (Join-Path $HOME ".gradle")
Add-MpExemption (Join-Path $env:LOCALAPPDATA "JetBrains")
Add-MpExemption (Join-Path $env:APPDATA "JetBrains")
Add-MpExemption "C:\my"

#>
$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

function Add-MpExemption {
    param(
        [string]$Path,
        [switch]$Apply
    )
    $mpperf = Get-MpPreference
    $exemptions = $mpperf.ExclusionPath.Split("`n")

    if ($Path.EndsWith('\')) {
        $Path = $Path.Substring(0, $Path.Length - 1)
    }
    if ($exemptions -icontains $Path) {
        return
    }
    if ($exemptions -icontains "$Path\") {
        return
    }
    Write-Host "Add $Path"
    if ($Apply) {
        Add-MpPreference -ExclusionPath $Path
    }
}

function Remove-MpExemption {
    param(
        [string]$Path,
        [switch]$Apply
    )
    $mpperf = Get-MpPreference
    $exemptions = $mpperf.ExclusionPath.Split("`n")

    if ($Path.EndsWith('\')) {
        $Path = $Path.Substring(0, $Path.Length - 1)
    }
    if ($exemptions -notcontains $Path) {
        return
    }
    Write-Host "Remove $Path"
    if ($Apply) {
        Remove-MpPreference -ExclusionPath $Path
    }
}
