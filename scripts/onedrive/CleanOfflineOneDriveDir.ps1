param(
    [string]$RootPath,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

function Process-File() {
    param(
        [Parameter(Mandatory, Position=0)]
        [System.IO.FileSystemInfo]$Item
    )

    if ($Item.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
        $Dir = [System.IO.DirectoryInfo]$Item

        # $children = Get-ChildItem -LiteralPath $File.FullName
        $children = $Dir.EnumerateFileSystemInfos()
        foreach ($child in $children) {
            Process-File $child
        }
    }
    else {
        $File = [System.IO.FileInfo]$Item
        if ($true `
            -and (0 -ne ($File.Attributes -band 0x00400000)) ` # RecallOnDataAccess
            ) {
            # -and $File.Attributes.HasFlag([System.IO.FileAttributes]::Archive) `
            # -and $File.Attributes.HasFlag([System.IO.FileAttributes]::SparseFile) `
            # -and $File.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) `
            # -and $File.Attributes.HasFlag([System.IO.FileAttributes]::Offline) `

            Write-Host $File.FullName
            # Write-Host $File.Length

            if (-not $DryRun) {
                $File.Delete()
            }
        }
    }
}

$root = Get-Item -LiteralPath $RootPath
Process-File $root
