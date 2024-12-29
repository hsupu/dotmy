param(
    [string]$GenDirPath,
    [switch]$Save
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrEmpty($GenDirPath)) {
    $GenDirPath = "C:\my\local\gen\bin"
}

$map = [System.Collections.Generic.Dictionary[string, string]]::new()

Push-Location $GenDirPath
try {
    $files = Get-ChildItem
    foreach ($file in $files) {
        if ($file.Name.StartsWith('.')) {
            Write-Host "SkipFile $($file.Name)"
            continue
        }
        # "FileSystemInfo.LinkTarget" since .NET 6
        if ($null -eq $file.LinkTarget) {
            # not a link
            Write-Host "SkipFile $($file.Name)"
            continue
        }
        $map.Add($file.Name, $file.LinkTarget) | Out-Null
    }

    foreach ($iter in $map.GetEnumerator()) {
        Write-Host "$($iter.Key) => $($iter.Value)"
        if ($Save) {
            # TODO
        }
    }
}
finally {
    Pop-Location
}
