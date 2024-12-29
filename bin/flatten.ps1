<#
.SYNOPSIS
Flatten a directory tree to its root
#>
param(
    [Parameter(Position=0)]
    [string]$root,

    [switch]$move,
    [switch]$copy,
    [switch]$y
)

if ([string]::IsNullOrEmpty($root)) {
    $root = "."
}
$root = Resolve-Path -Path $root -ErrorAction Stop
$rootlen = $root.Length

$srcs = @()
$subdirs = Get-ChildItem -Path $root -Directory -ErrorAction Stop
foreach ($subdir in $subdirs) {
    $srcs += Get-ChildItem -Path $subdir.FullName -File -Recurse -ErrorAction Stop
}

$map = [System.Collections.Generic.Dictionary[string, object]]::new()
foreach ($file in $srcs) {
    $OldFullName = $file.FullName.Substring($rootlen)
    $NewFullName = $(Join-Path $root $file.Name).Substring($rootlen)
    if ($map.ContainsKey($NewFullName)) {
        Write-Host "skip (SameName) $OldFullName"
    }
    else {
        $map.Add($NewFullName, [tuple]::Create($file))
        Write-Host "flatten $OldFullName to $NewFullName"
    }
}

if (-not $y) {
    $cmdstr = $move ? "move" : ($copy ? "copy" : "link")
    Write-Warning "Flatten ($cmdstr) `"$root`"?" -WarningAction Inquire
}

foreach ($pair in $map.GetEnumerator()) {
    $file = [IO.FileInfo]($pair.Value.Item1)
    $OldFullName = $file.FullName
    $NewFullName = Join-Path $root $file.Name
    # Write-Host "$OldFullName => $NewFullName"
    # continue

    if ($move) {
        Move-Item -Path $OldFullName -Destination $NewFullName -ErrorAction Stop | Out-Null
    }
    elseif ($copy) {
        Copy-Item -Path $OldFullName -Destination $NewFullName -ErrorAction Stop | Out-Null
    }
    else {
        New-Item -ItemType HardLink -Path $NewFullName -Value $OldFullName -ErrorAction Stop | Out-Null
    }
}
