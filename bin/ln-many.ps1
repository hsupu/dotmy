param(
    [Parameter(Mandatory, Position=0)]
    [string]$Src,

    [Parameter(Mandatory, Position=1)]
    [string]$Dst,

    [switch]$Dryrun
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$srcItems = Get-Item -Path $Src
if ($null -eq $srcItems) {
    Write-Error "SrcNotFound: $Src"
    exit(1)
}

foreach ($srcItem in $srcItems) {
    if (Test-Path -Path $Dst) {
        $dstPath = Join-Path $Dst $srcItem.Name
    }
    else {
        if (1 -ne $srcItems.Length) {
            Write-Error "DstNotExist: $Dst"
        }
        $dstPath = $Dst
    }

    if ($srcItem.Attributes.HasFlag([IO.FileAttributes]::Directory)) {
        if ($Dryrun) {
            Write-Host "mklink /d $dstPath $($srcItem.FullName)"
        }
        else {
            & cmd.exe /c mklink /d $dstPath $srcItem.FullName
        }
    }
    else {
        if ($Dryrun) {
            Write-Host "mklink $dstPath $($srcItem.FullName)"
        }
        else {
            & cmd.exe /c mklink $dstPath $srcItem.FullName
        }
    }
}
