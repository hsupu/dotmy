param(
    [string]$GenDirPath,
    [string]$ListFilePath,
    [switch]$Dryrun
)

$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

if ([string]::IsNullOrEmpty($GenDirPath)) {
    $GenDirPath = "C:\my\local\gen\bin"
}

if ([string]::IsNullOrEmpty($ListFilePath)) {
    $ListFilePath = "$PSScriptRoot\home.txt"
}

class Fwd
{
    [ValidateNotNullOrEmpty()]
    [string]$Path

    [string]$Args

    [string]ToString(){
        return ("`"{0}`" {1}" -f $this.Path, $this.Args)
    }
}

function substitute($s) {
    return Invoke-Expression "`"$s`""
}

$map = [System.Collections.Generic.Dictionary[string, Fwd]]::new()

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
    $r = $line.Substring($delim + 2).TrimStart()

    if ($r.StartsWith("`"")) {
        if (-not ($r -match "^`"(.+?)(?<!\\)`"(.*)$")) {
            Write-Error "Invalid $line"
            exit(1)
        }
        $rpath = ($Matches.1).Trim()
        $rargs = ($Matches.2).Trim()
    }
    elseif ($r.StartsWith("`'")) {
        if (-not ($r -match "^`'(.+?)(?<!\\)`'(.*)$")) {
            Write-Error "Invalid $line"
            exit(1)
        }
        $rpath = ($Matches.1).Trim()
        $rargs = ($Matches.2).Trim()
    }
    else {
        if (-not ($r -match "^(\S+)((?: .+)?)$")) {
            Write-Error "Invalid $line"
            exit(1)
        }
        $rpath = ($Matches.1).Trim()
        $rargs = ($Matches.2).Trim()
    }

    $val = [Fwd]::new()
    $val.Path = substitute $rpath
    $val.Args = $rargs
    $map.Add($key, $val) | Out-Null
}

if ($Dryrun) {
    foreach ($iter in $map.GetEnumerator()) {
        Write-Host "$($iter.Key) => $($iter.Value)"
    }
    exit(0)
}

. "$PSScriptRoot\funcs.ps1"

if (-not (Test-Path $GenDirPath -PathType Container)) {
    mkdir -p $GenDirPath | Out-Null
}

Push-Location $GenDirPath
try {
    foreach ($iter in $map.GetEnumerator()) {
        $delim = $iter.Key.LastIndexOf('.')
        if (-1 -eq $delim) {
            $ext = "ps1"
            $name = $iter.Key
        }
        else {
            $ext = $iter.Key.Substring($delim + 1).Trim()
            $name = $iter.Key.Substring(0, $delim)
        }

        if ("exe" -ieq $ext) {
            Add-Shim -DirPath $GenDirPath -Name $name -TargetPath $iter.Value.Path @($iter.Value.Args)
            continue
        }

        if ("ps1" -ieq $ext) {
            Add-Ps1 -DirPath $GenDirPath -Name $name -TargetPath $iter.Value.Path @($iter.Value.Args)
            continue
        }

        if ("cmd" -ieq $ext) {
            Add-Cmd -DirPath $GenDirPath -Name $name -TargetPath $iter.Value.Path @($iter.Value.Args)
            continue
        }

        if ("lnk" -ieq $ext) {
            Write-Host "NotImpl: $($iter.Key)"
            continue
        }

        Write-Error "UnknownType: $($iter.Key)"
    }
}
finally {
    Pop-Location
}
