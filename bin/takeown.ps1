param(
    [string]$RootDir,

    [switch]$Apply,
    [switch]$OneByOne
)

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$currentUserName = $currentUser.Name
# $currentUserSID = $currentUser.User.Value
# $currentUserName = $env:USER
$currentUserSID = & whoami /user

function Scan-Dir() {
    param(
        [IO.DirectoryInfo]$Dir
    )

    $items = Get-ChildItem $Dir
    foreach ($item in $items) {
        # https://learn.microsoft.com/zh-cn/dotnet/api/system.io.filesystemaclextensions.getaccesscontrol?view=net-6.0
        $acl = [IO.FileSystemAclExtensions]::GetAccessControl($item)
        if ($null -eq $acl) {
            Write-Error -ErrorAction Continue "Failed to GetAccessControl: $($item.FullName)"
            continue
        }

        # https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.objectsecurity.getowner?view=net-6.0
        [string]$owner = $acl.GetOwner([System.Security.Principal.NTAccount])
        # $owner : https://learn.microsoft.com/zh-cn/dotnet/api/system.security.principal.identityreference?view=net-6.0
        if ($owner -eq '') {
            Write-Error -ErrorAction Continue "Failed to GetOwner: $($item.FullName)"
            continue
        }
        elseif ($owner -ieq $currentUserName) {
            # Write-Host "Already $owner : $($item.FullName)"

            # https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.commonobjectsecurity.getaccessrules?view=net-6.0
            # bool includeExplicit, bool includeInherited
            $coll = $acl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
            # $coll : https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.authorizationrulecollection?view=net-6.0
            $found = $false
            $owned = $false
            foreach ($rule in $coll) {
                # $rule : https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=net-6.0
                # https://learn.microsoft.com/zh-cn/dotnet/api/system.security.principal.identityreference?view=net-6.0
                if ($rule.IdentityReference.Value -ieq $currentUserName) {
                    # $sid = $rule.IdentityReference.Translate([System.Security.Principal.SecurityIdentifier]).Value
                    # https://learn.microsoft.com/zh-cn/dotnet/api/system.security.accesscontrol.filesystemrights?view=net-6.0
                    if ($rule.FileSystemRights.HasFlag([System.Security.AccessControl.FileSystemRights]::FullControl)) {
                        $owned = $true
                        break
                    }

                    $found = $true
                    break
                }
            }

            if ($owned) {
                # Write-Host "Already owned : $($item.FullName)"
                continue
            }

            if ($Apply) {
                & icacls.exe $item.FullName /grant "$($currentUserName):F"
            }
        }
        else {
            Write-Host "Taking from $owner : $($item.FullName)"

            if ($Apply) {
                & icacls.exe $item.FullName /setowner $currentUserName
                & icacls.exe $item.FullName /grant "$($currentUserName):F"
            }
        }

        if ($item.Attributes.HasFlag([IO.FileAttributes]::Directory)) {
            Scan-Dir -Dir $item
        }
    }
}

if ($RootDir -eq '') {
    $RootDir = $PWD
}

if ($OneByOne) {
    Scan-Dir -Dir (Get-Item -LiteralPath $RootDir)
}
else {
    # /T : Traverse all subfolders to match files.
    # /L : Perform the operation on a symbolic link itself versus its target.
    & icacls.exe "$RootDir\*" /T /L /setowner $currentUserName
    & icacls.exe "$RootDir\*" /T /L /grant "$($currentUserName):F"
}
