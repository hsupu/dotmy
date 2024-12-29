<#
.SYNOPSIS
能够处理畸形文件名的重命名脚本

.NOTES
"\\?\" prefix to disable parsing on win32 API

.LINK
https://superuser.com/questions/90227/files-with-illegal-filenames
https://superuser.com/questions/31587/how-to-force-windows-to-rename-a-file-with-a-special-character
https://docs.microsoft.com/en-us/windows/desktop/fileio/naming-a-file

#>
param(
    [Parameter(Mandatory, Position=0)]
    [string]$SrcPath,

    [Parameter(Mandatory, Position=0)]
    [string]$DstPath,

    [switch]$dummy
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

if (-not $script:SrcPath.StartsWith("\\?\")) {
    $srcDir = Resolve-Path (Join-Path $script:SrcPath "..")
    $srcFilename = [IO.Path]::GetFileName($script:SrcPath)
    $script:SrcPath = Join-Path "\\?\" $srcDir $srcFilename
}
if (-not $script:DstPath.StartsWith("\\?\")) {
    $dstDir = Resolve-Path (Join-Path $script:DstPath "..")
    $dstFilename = [IO.Path]::GetFileName($script:DstPath)
    $script:DstPath = Join-Path "\\?\" $dstDir $dstFilename
}

if ($script:SrcPath -eq $script:DstPath) {
    return
}
Move-Item -LiteralPath $script:SrcPath -Destination $script:DstPath
