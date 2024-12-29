param(
    [Parameter(Mandatory, Position=0)]
    [string]$Src,

    [Parameter(Mandatory, Position=1)]
    [string]$Dst,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$SrcItem = Get-Item $Src
if ($null -eq $SrcItem) {
    Write-Error "SrcNotExist: $Src"
    exit(1)
}

$DstFull = Join-Path (Resolve-Path (Join-Path $env:DOTMY "programs")) $Dst
if (Test-Path $DstFull) {
    Write-Error "DstExisted: $DstFull"
    exit(1)
}

Write-Host "asmy $($SrcItem.Name) => $DstFull"

$DstDir = Join-Path $DstFull ".."
if (-not (Test-Path $DstDir)) {
    mkdir -p $DstDir
}
Move-Item -Path $SrcItem.FullName -Destination $DstFull | Out-Null

if ($SrcItem.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    & cmd /c mklink /d $SrcItem.Name $DstFull
}
else {
    & cmd /c mklink $SrcItem.Name $DstFull
}
