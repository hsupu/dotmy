param(
    [string]$GenDirPath,
    [string]$ListFilePath,
    [switch]$Dryrun
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrEmpty($GenDirPath)) {
    $GenDirPath = "C:\my\local\gen\bin"
}

if ([string]::IsNullOrEmpty($ListFilePath)) {
    $ListFilePath = Join-Path $PSScriptRoot "home.txt"
}

$map = [System.Collections.Generic.Dictionary[string, string]]::new()

$lines = Get-Content $ListFilePath
foreach ($line in $lines) {
    $line = $line.Trim()
    if ([string]::IsNullOrEmpty($line)) {
        continue
    }

    if ($line.StartsWith('#') -or $line.StartsWith(';')) {
        # comment
        continue
    }

    $delim = $line.IndexOf('=>')
    if (-1 -eq $delim) {
        Write-Error "bad: $line"
        continue
    }

    $key = $line.Substring(0, $delim).TrimEnd()
    $val = $line.Substring($delim + 2).TrimStart()

    $map.Add($key, $val) | Out-Null
}

if ($Dryrun) {
    foreach ($iter in $map.GetEnumerator()) {
        Write-Host "$($iter.Key) => $($iter.Value)"
    }
    exit(0)
}

if (-not (Test-Path $GenDirPath -PathType Container)) {
    mkdir -p $GenDirPath | Out-Null
}

Push-Location $GenDirPath
try {
    foreach ($iter in $map.GetEnumerator()) {
        $path = "./$($iter.Key)"
        if (Test-Path $path) {
            $item = Get-Item $path
            if ($item.LinkTarget -eq $iter.Value) {
                Write-Host "Skip $($iter.Key) => $($item.LinkTarget)"
                continue
            }

            $skip = $false

            if ($null -eq $item.LinkTarget) {
                if (0 -ne $item.Length) {
                    Write-Host "Found File $($iter.Key)"
                    $skip = $true
                }
                else {
                    Write-Host "Override EmptyFile $($iter.Key) => $($iter.Value)"
                    Remove-Item $item
                }
            }
            else {
                Write-Host "Found Link $($iter.Key) => $($item.LinkTarget)"
                $skip = $true
            }

            if ($skip) {
                continue # TODO: prompt to override
            }
        }
        & sudo cmd.exe /c mklink $iter.Key $iter.Value
    }
}
finally {
    Pop-Location
}
