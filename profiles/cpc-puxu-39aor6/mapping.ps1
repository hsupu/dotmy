
$global:CacheRootRedirectTo = "E:\cache"
$global:VolatileRootRedirectTo = "E:\volatile"

$global:CacheDrive = [IO.Path]::GetPathRoot($CacheRootRedirectTo)

# suffix '/' matters
$mapping = @(

    @('C:/AnyBuildCache', '$($CacheDrive)/AnyBuildCache/'),
    @('C:/CloudBuildCache', '$($CacheDrive)/CloudBuildCache/'),
    @('C:/packagecache', '$($CacheDrive)/packagecache/'),

    # mklink /j
    @('C:/.tools/.nuget', '$($CacheDrive)/cache/.nuget/'),
    @('C:/.tools/CxCache', '$($CacheDrive)/CxCache/'),
    @('C:/.tools/QuickBuild/_cache', '$($CacheDrive)/cache/QuickBuild_cache/'),

    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),

    @('C:/ct', '$($HddDrive)/ct/'),
    @('C:/drops', '$($HddDrive)/drops/'),

    @()
)

$userEnv = @{
}

$machineEnv = @{
    'NUGET_CREDENTIALPROVIDER_FORCE_CANSHOWDIALOG_TO' = 'True';
    'NUGET_HTTP_CACHE_PATH' = 'E:\.nuget\v3-cache';
    'NUGET_NETCORE_PLUGIN_PATHS' = 'E:\.nuget\plugins\netcore\CredentialProvider.Microsoft\CredentialProvider.Microsoft.dll';
    'NUGET_NETFX_PLUGIN_PATHS' = 'E:\.nuget\plugins\netfx\CredentialProvider.Microsoft\CredentialProvider.Microsoft.exe';
    'NUGET_PACKAGES' = 'E:\.nuget\packages';
    'NUGET_PLUGIN_PATHS' = 'E:\.nuget\plugins\netfx\CredentialProvider.Microsoft\CredentialProvider.Microsoft.exe';
    'NUGET_PLUGINS_CACHE_PATH' = 'E:\.nuget\plugins-cache';
    'NugetMachineInstallRoot' = 'E:\CxCache';
    'PACKAGE_CACHE_DIRECTORY' = 'E:\packagecache';
}

$envpathUserSnapshot = @(
    'C:\my\bin-work',
    'C:\my\bin',
    'C:\my\scripts',
    'C:\my\local\bin',

    'C:\opt\scoop\apps\gsudo\current',
    'C:\opt\scoop\shims',

    '%APPDATA%\npm',

    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',
    '%USERPROFILE%\.dotnet\tools',
    '%USERPROFILE%\go\bin',
    '%LOCALAPPDATA%\Programs\Python\Launcher\',

    '%LOCALAPPDATA%\Microsoft\WindowsApps',

    ''
)

$envpathMachineSnapshot = @(
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    '%SystemRoot%\System32\WindowsPowerShell\v1.0\',
    '%SystemRoot%\System32\OpenSSH\',

    'C:\Program Files\PowerShell\7\',
    'C:\Program Files\dotnet\',
    'C:\.tools\dotnet',

    'C:\ProgramData\chocolatey\bin',

    'C:\Program Files\Git LFS',
    'C:\Program Files\Git\cmd',

    'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin',
    'C:\Program Files\Azure Dev CLI',

    'C:\.tools\QuickBuild',
    'C:\.tools\AnyBuild',

    'C:\Program Files\Microsoft\jdk-11.0.24.8-hotspot\bin',
    'C:\Program Files (x86)\Common Files\Oracle\Java\java8path',

    'C:\Program Files\Go\bin',
    'C:\Program Files\nodejs\',
    'C:\Program Files (x86)\scala\bin',

    'C:\Program Files\Docker\Docker\resources\bin',

    'C:\Program Files\GitHub CLI\',

    'C:\Program Files\Microsoft Dev Box Agent\1.0.02803.3598\4a77046b-785a-49ef-bdb2-74b30c5f4a76\Scripts',
    'C:\Program Files\Microsoft Dev Box Agent\Scripts',

    'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\',
    'C:\Program Files\Microsoft SQL Server\150\Tools\Binn\',

    'C:\Users\VMAdmin\AppData\Local\Microsoft\WindowsApps', # not found
    'C:\Windows\system32\config\systemprofile\AppData\Local\Microsoft\WindowsApps', # not found

    ''
)

$includes = @(
    'traits-msft',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
