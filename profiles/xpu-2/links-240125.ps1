param(
    # C:\my\local
    [Parameter(Mandatory)]
    [string]$MyLocalRoot,

    # D:\cache
    [Parameter(Mandatory)]
    [string]$CacheRoot,

    # D:\volatile
    [Parameter(Mandatory)]
    [string]$VolatileRoot,

    [switch]$UseJunction
)

$syncRoot = "$($env:OneDriveCommercial)\my"
if (-not (Test-Path $syncRoot -PathType Container)) {
    Write-Host "OneDriveCommericial not linked"
    return
}

$ErrorActionPreference = 'Stop'
trap { throw $Error[0]; }

$MyLocalRootTarget = Resolve-Path $MyLocalRoot
$CacheRootTarget = Resolve-Path $CacheRoot
$VolatileRootTarget = Resolve-Path $VolatileRoot

$MyRoot = "C:\my";
$MyLocalRootTarget = (Join-Path $MyRoot "local");
$dotmyDir = "C:\my\local\var\dotmy";
$CacheDrive = [IO.Path]::GetPathRoot($CacheRoot)
$CacheRoot = "C:\cache"
$VolatileDrive = [IO.Path]::GetPathRoot($VolatileRoot)
$VolatileRoot = "C:\volatile"
$HddDrive = "D:"

$linkDirs = @{
    "C:\cache" = $CacheRootTarget;
    "C:\volatile" = $VolatileRootTarget;

    (Join-Path $MyRoot "local\app-cli") = (Join-Path $MyLocalRoot "app-cli");
    (Join-Path $MyRoot "local\app-gui") = (Join-Path $MyLocalRoot "app-gui");
    (Join-Path $MyRoot "local\app-msft") = (Join-Path $MyLocalRoot "app-msft");
    (Join-Path $MyRoot "local\srv") = (Join-Path $MyLocalRoot "srv");
    (Join-Path $MyRoot "local\var") = (Join-Path $MyLocalRoot "var");

    (Join-Path $MyRoot "wsl") = (Join-Path $MyLocalRoot "wsl");

    # 请自行复制 Microsoft.PowerShell_profile.ps1
    (Join-Path $HOME "Documents\PowerShell\Sync") = $dotmyDir;
    (Join-Path $MyRoot "bin") = (Join-Path $dotmyDir "bin");

    (Join-Path $MyRoot "bin-work") = (Join-Path $env:OneDriveCommercial "my\bin-work");
    (Join-Path $MyRoot "scripts") = (Join-Path $env:OneDriveCommercial "my\scripts");
    # (Join-Path $MyRoot "notes") = (Join-Path $env:OneDriveCommercial "my\notes");
    # (Join-Path $MyRoot "start") = (Join-Path $env:OneDriveCommercial "my\start");
    (Join-Path $MyRoot "var") = (Join-Path $env:OneDriveCommercial "my\var");

    (Join-Path $HOME "scoop") = "$MyRoot\local\opt\scoop";

    # (Join-Path $HOME ".ssh") = (Join-Path $env:OneDriveCommercial "my\var\dotfiles\.ssh";
    # (Join-Path $HOME ".config") = (Join-Path $env:OneDriveCommercial "my\var\dotfiles\.config";

    (Join-Path $HOME ".m2\repositories") = (Join-Path $CacheRoot "mvn-repo-local");

    # ObjectStore nuget pkgs 单独配置 $env:INETROOT\private\nuget => nuget_pkgs_ObjectStore
    (Join-Path $HOME ".nuget") = (Join-Path $CacheRoot "nuget");
    # (Join-Path $HOME ".nuget\packages") = (Join-Path $CacheRoot "nuget-pkgs");

    (Join-Path $env:LOCALAPPDATA "Microsoft\vscode-cpptools") = (Join-Path $CacheRoot "vscode-cpptools");
    # (Join-Path $env:APPDATA "Code\User\workspaceStorage") = (Join-Path $CacheRoot "vscode-workspaceStorage");

    (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Cache") = (Join-Path $CacheRoot "edge\default-user");
    (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Code Cache") = (Join-Path $CacheRoot "edge\default-user-code");

    # They complaints if not in root
    "C:\corextcache" = (Join-Path $HddDrive "corextcache");
    "C:\packagecache" = (Join-Path $HddDrive "packagecache");
    "C:\CloudBuildCache" = (Join-Path $HddDrive "CloudBuildCache");

    "C:\ct" = (Join-Path $HddDrive "ct");
    "C:\drops" = (Join-Path $HddDrive "drops");
}

$linkFiles = @{
    # (Join-Path $HOME ".gitconfig") = (Join-Path $env:OneDriveCommercial "my\var\dotfiles\.gitconfig");
}

foreach ($kvp in $linkDirs.GetEnumerator()) {
    $link = $kvp.Key
    $source = $kvp.Value

    if ([string]::IsNullOrEmpty($link)) {
        continue
    }

    if (-not (Test-Path $source)) {
        Write-Host "Source NotFound $source"
        continue
    }

    $sourceItem = Get-Item $source
    if (-not ($sourceItem.Attributes.HasFlag([System.IO.FileAttributes]::Directory))) {
        Write-Host "Source NotDir $($sourceItem.FullName)"
        continue
    }

    $linkItem = Get-Item $link -ErrorAction SilentlyContinue
    if ($null -ne $linkItem) {
        if ($sourceItem.FullName -eq $linkItem.FullName) {
            Write-Host "SamePath $($linkItem.FullName)"
            continue
        }

        if ($null -eq $linkItem.LinkType) {
            Write-Host "NotLink $($linkItem.FullName)"
            continue
        }

        $linkTarget = $linkItem.LinkTarget
        if ($linkTarget -ne $sourceItem.FullName) {
            Write-Host "Link TargetDiff $($linkItem.FullName) => $linkTarget ($($linkItem.LinkType)) / Expected $($sourceItem.FullName)"
            continue
        }

        $linkTypeExpected = $UseJunction ? "JunctionLink" : "SymbolicLink"
        if ($linkTypeExpected -ne $linkItem.LinkType) {
            Write-Host "Link TypeDiff $($linkItem.FullName) => $linkTarget ($($linkItem.LinkType))"
            continue
        }

        # same
        continue
    }

    if ($UseJunction) {
        & cmd.exe /c mklink /j $link $sourceItem.FullName
    }
    else {
        & cmd.exe /c mklink /d $link $sourceItem.FullName
    }
}

foreach ($kvp in $linkFiles.GetEnumerator()) {
    $link = $kvp.Key
    $source = $kvp.Value

    if ([string]::IsNullOrEmpty($link)) {
        continue
    }

    if (-not (Test-Path $source)) {
        Write-Host "Source NotFound $source"
        continue
    }

    $sourceItem = Get-Item $source
    if ($sourceItem.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
        Write-Host "Source IsDir $($sourceItem.FullName)"
        continue
    }

    $linkItem = Get-Item $link -ErrorAction SilentlyContinue
    if ($null -ne $linkItem) {
        if ($null -eq $linkItem.LinkType) {
            Write-Host "NotLink $($linkItem.FullName)"
            continue
        }

        $linkTarget = $linkItem.LinkTarget
        if ($linkTarget -ne $sourceItem.FullName) {
            Write-Host "Link TargetDiff $($linkItem.FullName) => $linkTarget ($($linkItem.LinkType))"
            continue
        }

        $linkTypeExpected = $UseJunction ? "JunctionLink" : "SymbolicLink"
        if ($linkTypeExpected -ne $linkItem.LinkType) {
            Write-Host "Link TypeDiff $($linkItem.FullName) => $linkTarget ($($linkItem.LinkType))"
            continue
        }

        # same
    }

    & cmd.exe /c mklink $link $sourceItem.FullName
}
