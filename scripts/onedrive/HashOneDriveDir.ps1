param(
    [string]$RootPath,

    [switch]$PrintOffline,

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

            if ($PrintOffline) {
                Write-Output "offline $($File.FullName.Substring($RootPath.Length))"
            }
        }
        else {
            if ($DryRun) {
                Write-Output "online $($File.FullName.Substring($RootPath.Length))"
            }
            else {
                $hash = Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256 -ErrorAction Continue
                if ($null -eq $hash) {
                    continue
                }
                Write-Output "$($hash.Hash) $($File.FullName.Substring($RootPath.Length))"
            }
        }
    }
}

$root = Get-Item -LiteralPath $RootPath
Process-File $root
