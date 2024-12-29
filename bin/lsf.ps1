<#
.SYNOPSIS
List Files - Print its LinkType
#>
param(
    [Parameter(Mandatory, Position=0)]
    [string]$Path,

    [switch]$PrintRegularFile,
    [switch]$PrintRegularDir,
    [switch]$PrintHardlink,

    [switch]$Recursive,
    [switch]$FollowDirSymlink,
    [switch]$FollowJunction,

    [string]$IgnoreFilePath,

    [switch]$dummy
)

function List-File() {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileSystemInfo]$File
    )

    if ($File.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
        $Dir = [System.IO.DirectoryInfo]$File

        # if ($File.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
        #     continue
        # }

        switch ($File.LinkType) {
            "SymbolicLink" {
                $linkType = "DirSymlink"
                $list = $script:FollowDirSymlink
            }
            "Junction" {
                $linkType = "Junction"
                $list = $script:FollowJunction
            }
            "HardLink" {
                if ($script:PrintHardlink -or $script:PrintRegularDir) {
                    $fileType = "Hardlink"
                }
                $list = $script:Recursive
            }
            "" {
                if ($script:PrintRegularDir) {
                    $fileType = "Dir"
                }
                $list = $script:Recursive
            }
            default {
                $linkType = $_
            }
        }

        if ($null -eq $linkType) {
            if ($null -ne $fileType) {
                Write-Output "$fileType $($File.FullName)"
            }
        }
        else {
            Write-Output "$linkType $($File.FullName) => $($File.LinkTarget)"
        }

        if ($list) {
            # $children = Get-ChildItem -LiteralPath $File.FullName
            $children = $Dir.EnumerateFileSystemInfos()
            foreach ($child in $children) {
                List-File -File $child
            }
        }
    }
    else {
        # $File = [System.IO.FileInfo]$File

        switch ($File.LinkType) {
            "SymbolicLink" {
                $linkType = "FileSymlink"
            }
            "HardLink" {
                if ($script:PrintHardlink -or $script:PrintRegularFile) {
                    $fileType = "Hardlink"
                }
            }
            "" {
                if ($script:PrintRegularFile) {
                    $fileType = "File"
                }
            }
            default {
                $linkType = $_
            }
        }

        if ($null -eq $linkType) {
            if ($null -ne $fileType) {
                Write-Output "$fileType $($File.FullName)"
            }
        }
        else {
            Write-Output "$linkType $($File.FullName) => $($File.LinkTarget)"
        }
    }
}

$file = Get-Item -LiteralPath $Path
List-File -File $file
