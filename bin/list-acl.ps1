param(
    [string]$Path
)

$isPwsh = ([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("6.0")) -ge 0

if ($Path.StartsWith('\\.\pipe\')) {
    if ($isPwsh) {
        # $pipe = [System.IO.DirectoryInfo]::new($pipe)
        # [System.IO.FileSystemAclExtensions]::GetAccessControl($pipe)

        # $sections = [Security.AccessControl.AccessControlSections]::Access -bor [Security.AccessControl.AccessControlSections]::Owner -bor [Security.AccessControl.AccessControlSections]::Group
        # $pipe = [Security.AccessControl.DirectorySecurity]::new($pipe, $sections)
        # $pipe
    }
    else {
        [System.IO.Directory]::GetAccessControl($Path)
    }
}
elseif ($isPwsh) {
    $pipe = [System.IO.DirectoryInfo]::new($pipe)
    [System.IO.FileSystemAclExtensions]::GetAccessControl($pipe)
}
else {
    $isDir = (Test-Path -LiteralPath $Path -PathType Container)

    if ($isDir) {
        [System.IO.Directory]::GetAccessControl($Path)
    }
    else {
        [System.IO.File]::GetAccessControl($Path)
    }
}
