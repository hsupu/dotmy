# Install-Module -Scope CurrentUser Microsoft.PowerShell.ConsoleGuiTools
# Install-Module -Scope CurrentUser VSSetup
param()

$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

$vers = [Collections.Generic.List[IO.FileSystemInfo]]::new()

$vsInstances = Get-VSSetupInstance -Prerelease
foreach ($vsInstance in $vsInstances) {
    $msvcRoot = $(Join-Path $vsInstance.InstallationPath "VC\Tools\MSVC")
    if (Test-Path -Path $msvcRoot -PathType Container) {
        foreach ($_ in $(Get-ChildItem $msvcRoot)) {
            if (Test-Path -Path $_.FullName -PathType Container) {
                $vers.Add($_) | Out-Null
            }
        }
    }
}

if (0 -eq $vers.Length) {
    Write-Error "MSVC not found"
    exit(1)
}

function Select-ZipWithIndex() {
    [CmdletBinding()]
    param(
        [object[]]$list
    )

    return 0..($list.Length - 1) | ForEach-Object { [PSCustomObject]@{
        Index = $_;
        Name = $list[$_];
    } }
}

$zipped = Select-ZipWithIndex($vers | ForEach-Object { $_.Name })
$selected = $zipped | Out-ConsoleGridView -OutputMode Single -Title "Select symlink from"
if ($null -eq $selected) {
    Write-Host "User cancelled"
    exit(0)
}
Write-Host "Select: $selected"

$dir = "C:\my\local\links"
$target = Join-Path $dir "msvc"
if (-not (Test-Path $dir -PathType Container)) {
    mkdir -p $dir
}
elseif (Test-Path -Path $target) {
    Remove-Item $target
}

& cmd /c mklink /j $target $vers[$selected.Index].FullName
