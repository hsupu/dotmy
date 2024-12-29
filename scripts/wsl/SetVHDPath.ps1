<#
.LINK
https://learn.microsoft.com/zh-cn/windows/wsl/disk-space

#>
param(
    [Parameter(Mandatory)]
    [string]$Distro,

    [Parameter()]
    [string]$DirPath,

    [switch]$DryRun
)

& wsl --manage $Distro --move $DirPath
return

$ErrorActionPreference = 'Stop'
trap { throw $_ }

[Microsoft.Win32.RegistryKey]$regKeyLxss = Get-Item -LiteralPath "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss"

if ('' -eq $Distro) {
    $uuid = $regKeyLxss.GetValue("DefaultDistribution")
    # $regKeyDistro = Get-Item -LiteralPath "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss\$uuid"
    $regKeyDistro = $regKeyLxss.OpenSubKey($uuid)
}
else {
    $regKeyDistro = $regKeyLxss | Get-ChildItem | Where-Object { $_.GetValue("DistributionName") -ieq $Distro } | Select-Object -First 1
}

if ($null -eq $regKeyDistro) {
    throw "Unexpected"
}

if ([string]::IsNullOrEmpty($DirPath)) {
    $query = $true
    $DirPath = $regKeyDistro.GetValue("BasePath")
}
else {
    $query = $false
    $DirPath = Resolve-Path -LiteralPath $DirPath
}

$vhdxPath = (Join-Path $DirPath "ext4.vhdx")
if (-not (Test-Path -LiteralPath $vhdxPath)) {
    throw "NotExist $vhdxPath"
}

if ($query) {
    Write-Output $DirPath
}
else {
    $unc = Join-Path "\\?\" $DirPath
    if ($DryRun) {
        Write-Output "Set $($regKeyDistro.Name) :: BasePath = $unc"
    }
    else {
        $regKeyDistro.SetValue("BasePath", $unc, [Microsoft.Win32.RegistryValueKind]::String)
    }
}
