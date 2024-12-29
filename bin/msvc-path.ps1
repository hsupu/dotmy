<#
.SYNOPSIS
Detect and add a folder symlink to msvc root

.NOTES
Install-Module -Scope CurrentUser Microsoft.PowerShell.ConsoleGuiTools
Install-Module -Scope CurrentUser VSSetup

#>
param(
    [string]$LinkTo
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

function EnsureModule([string]$Name) {
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Install-Module -Scope CurrentUser -Name $Name
    }
}
EnsureModule 'Microsoft.PowerShell.ConsoleGuiTools'
EnsureModule 'VSSetup'

$vers = [Collections.Generic.List[IO.FileSystemInfo]]::new()

$inss = Get-VSSetupInstance -Prerelease -All
foreach ($ins in $inss) {
    if ([Microsoft.VisualStudio.Setup.Configuration.InstanceState]::Complete -ne $ins.State) {
        Write-Warning -WarningAction Continue -Message "Skip incomplete instance $($ins.DisplayName) $($ins.InstallationPath)"
        continue
    }

    $msvcRoot = Join-Path $ins.InstallationPath "VC\Tools\MSVC"
    if (-not (Test-Path -LiteralPath $msvcRoot -PathType Container)) {
        Write-Warning -WarningAction Continue -Message "MSVC not installed in $($ins.DisplayName) $($ins.InstallationPath)"
        continue
    }

    Get-ChildItem -LiteralPath $msvcRoot -Directory | ForEach-Object {
        # if ($_.Name -match '^\d+\.\d+\.\d+\.\d+$') {
        if (Test-Path -LiteralPath (Join-Path $_ "bin")) {
            $vers.Add($_) | Out-Null
        }
    }
}

if (0 -eq $vers.Count) {
    throw "No valid MSVC found"
}
Write-Verbose "Found $($vers.Count) MSVC instance(s)"
$vers | ForEach-Object { $_.FullName | LinuxizePathSlash }

if ('' -eq [string]$LinkTo) {
    Write-Verbose "-LinkTo is empty, no symlink created"
    return
}

function Select-ZipWithIndex {
    [CmdletBinding()]
    param(
        [object[]]$list
    )

    return 0..($list.Count - 1) | ForEach-Object { [PSCustomObject]@{
        Index = $_;
        Name = $list[$_];
    } }
}

# just ensure parent dir exists
$LinkToParent = Resolve-Path -ErrorAction Stop -LiteralPath (Join-Path $LinkTo "..")

if (1 -eq $vers.Count) {
    $selected = 0
    $LinkSrc = $vers[0].FullName
}
else {
    $zipped = Select-ZipWithIndex($vers | ForEach-Object { $_.Name })
    $selected = $zipped | Out-ConsoleGridView -OutputMode Single -Title "Select symlink from"
    if ($null -eq $selected) {
        Write-Host "User cancelled"
        return
    }
    $selected = $selected.Index
    $LinkSrc = $vers[$selected].FullName
}
Write-Host "Selected $selected $LinkSrc"

# $dir = "C:\my\local\links"
# $target = Join-Path $dir "msvc"
# if (-not (Test-Path $dir -PathType Container)) {
#     mkdir -p $dir
# }
if (Test-Path -LiteralPath $LinkTo) {
    $existing = Get-Item -LiteralPath $LinkTo
    if ($null -eq $existing.LinkType) {
        Write-Host "Existing $($existing.FullName) Attrs: $($existing.Attributes)"
    }
    elseif ($existing.LinkTarget -ieq $LinkSrc) {
        Write-Host "Already linked"
        return
    }
    else {
        Write-Host "Existing link $($existing.FullName) => $($existing.LinkType) $($existing.LinkTarget)"
    }

    Remove-Item -Confirm $LinkTo
}

& cmd /c mklink /j $LinkTo $LinkSrc
