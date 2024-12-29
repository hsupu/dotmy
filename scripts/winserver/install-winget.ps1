# https://github.com/microsoft/winget-cli/issues/700
# 210623 https://stackoverflow.com/questions/68100663/how-do-i-install-winget-on-windows-server-2019
# 200522 https://serverfault.com/questions/1018220/how-do-i-install-an-app-from-windows-store-using-powershell

# 依赖：240125 有效
#

# VCLibs
Add-AppxPackage 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

# Microsoft.UI.Xaml from NuGet
$splat = @{
    Uri = "https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3";
    OutFile = ".\microsoft.ui.xaml.2.7.3.zip";
}
Invoke-WebRequest @splat
Expand-Archive .\microsoft.ui.xaml.2.7.3.zip
Add-AppxPackage .\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx

# 主体 winget (Microsoft.DesktopInstaller) from GitHub
#

$splat = @{
    Method = "GET";
    Uri = "https://api.github.com/repos/microsoft/winget-cli/releases/latest";
}
Invoke-RestMethod @splat

$splat = @{
    Uri = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle";
    OutFile = ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle";
}
Invoke-WebRequest @splat
# 可以从这里停下，手动安装，就没啥事了

$splat = @{
    Uri = ($LatestRelease.assets | Where-Object {$_.name -like '*license*.xml'}).browser_download_url
    OutFile = ".\winget.license.xml";
}
Invoke-WebRequest @splat

$splat = @{
    Path = ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle";
}
Add-AppxPackage @splat

$splat = @{
    Verbose = $true;
    Online = $true;
    PackagePath = ".\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle";
    LicensePath = ".\winget.license.xml";
}
Add-AppxProvisionedPackage @splat

# create reparse point
$SetExecutionAliasSplat = @{
    Path        = "$([System.Environment]::SystemDirectory)\winget.exe"
    PackageName = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
    EntryPoint  = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe!winget"
    Target      = "$((Get-AppxPackage Microsoft.DesktopAppInstaller).InstallLocation)\AppInstallerCLI.exe"
    AppType     = 'Desktop'
    Version     = 3
}
Set-ExecutionAlias @SetExecutionAliasSplat
& explorer.exe "shell:appsFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe!winget"

# Get access to the winget folder, so we can run winget.exe
$folderMask = "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*"
$folders = Get-ChildItem -Path $folderMask -Directory | Where-Object { $_.Name -like "*_x64_*" }
foreach ($folder in $folders) {
    $folderPath = $folder.FullName
    & TAKEOWN /F $folderPath /R /A /D Y
    & ICACLS $folderPath /grant Administrators:F /T
}

# $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
# if ($ResolveWingetPath){
#         $WingetPath = $ResolveWingetPath[-1].Path
# }
# $ENV:PATH += ";$WingetPath"
