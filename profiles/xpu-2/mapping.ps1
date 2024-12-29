<#
.NOTES
曾经设想把 VolatileRoot 置于 ramdisk，但重启即丢相比占空更麻烦，在 SSD 富裕后就放弃了
#>

$global:MyCacheRoot = "C:\cache"
$global:MyVolatileRoot = "C:\volatile"

$global:CacheRootRedirectTo = "V:\cache"
$global:VolatileRootRedirectTo = "V:\volatile"

$global:CacheDrive = [IO.Path]::GetPathRoot($CacheRootRedirectTo)
$global:HddDrive = "D:"
$global:RamdiskDrive = "R:"

# suffix '/' matters
$mapping = @(
    @('$MyCacheRoot', '$CacheRootRedirectTo/'),
    @('$MyVolatileRoot', '$VolatileRootRedirectTo/'),

    @('C:/corextcache', '$($CacheDrive)/corextcache/'),
    @('C:/packagecache', '$($CacheDrive)/packagecache/'),
    @('C:/CloudBuildCache', '$($CacheDrive)/CloudBuildCache/'),

    # @('$HOME/scoop', '$($env:SCOOP)/'),
    @('C:/my/local/opt/scoop', '$($env:SCOOP)/'),

    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:APPDATA)/JetBrains/IntellijIDEA2024.1/', '$($env:DOTMY)/programs/jetbrains/idea64.exe.vmoptions', @{ copy=$true }),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @('$HOME/vimfiles', '.vim/', @{ relative=$true }),
    @('C:/opt/ja-netfilter-all', 'jetbra-240701/', @{ relative=$true }),

    # Using CacheDrive
    #
    # @('C:/my/local/app-cli', '$($CacheDrive)/my/app-cli/'),
    # @('C:/my/local/app-gui', '$($CacheDrive)/my/app-gui/'),
    # @('C:/my/local/srv', '$($CacheDrive)/my/srv/'),
    @('C:/opt/cargo', '$($CacheDrive)/opt/cargo/'),
    @('C:/opt/msft', '$($CacheDrive)/opt/msft/'),
    @('C:/opt/rustup', '$($CacheDrive)/opt/rustup/'),
    @('C:/opt2', '$($CacheDrive)/opt/'),

    # Using CacheRoot
    #
    # @('$($env:APPDATA)/Code/User/workspaceStorage', '$(env:MyCacheRoot)/vscode-workspaceStorage/'),
    # @('$($env:LOCALAPPDATA)/Microsoft/Edge/User Data/Default/Cache', '$($MyCacheRoot)/edge/default-user/'),
    # @('$($env:LOCALAPPDATA)/Microsoft/Edge/User Data/Default/Code Cache', '$($MyCacheRoot)/edge/default-user-code/'),
    @('$($env:LOCALAPPDATA)/Microsoft/vscode-cpptools', '$($MyCacheRoot)/vscode-cpptools/'),
    # ObjectStore nuget pkgs 单独配置 $env:INETROOT\private\nuget => nuget_pkgs_ObjectStore
    @('$HOME/.nuget', '$($MyCacheRoot)/nuget/'),
    @('$HOME/.m2/repositories', '$($MyCacheRoot)/mvn-repo-local/'),
    @('C:/my/local/opt/vcpkg', '$($MyCacheRoot)/vcpkg/'),

    # Using HddDrive
    #
    @('C:/ct', '$($HddDrive)/ct/'),
    @('C:/drops', '$($HddDrive)/drops/'),

    # Using OneDriveCommercial
    #
    # @('$HOME/.config', '$($env:OneDriveCommercial)/my/var/dotfiles/.config/'),
    # @('$HOME/.ssh', '$($env:OneDriveCommercial)/my/var/dotfiles/.ssh/'),

    @()
)

$userEnv = @{
    'NugetMachineInstallRoot' = 'C:\corextcache';
    'PACKAGE_CACHE_DIRECTORY' = 'C:\packagecache';
}

$envpathUserSnapshot = @(
    'C:\opt\scoop\apps\gsudo\current',
    'C:\my\bin-work',
    'C:\my\bin',
    'C:\my\scripts',
    '%USERPROFILE%\.local\bin', # 'C:\my\local\bin',
    # 曾有 C:\my\local\gen\bin，不再使用，已并入 C:\my\bin-work

    'C:\opt\scoop\shims',
    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',

    'C:\opt\scoop\apps\nvm\current', # nvm

    '%USERPROFILE%\.dotnet\tools', # installed "dotnet tools"
    'C:\opt\scoop\apps\pyenv\current\pyenv-win\shims', # python pip etc.
    '%LOCALAPPDATA%\pnpm', # %PNPM_HOME%
    '%USERPROFILE%\go\bin',
    'C:\opt\cargo\bin', # rustup rustc cargo rls etc.
    'C:\opt\scoop\apps\nvm\current\nodejs\nodejs', # node npm etc.
    'C:\opt\scoop\apps\temurin21-jdk\current\bin',

    '%LOCALAPPDATA%\CloudBuild',
    '%LOCALAPPDATA%\CloudTest',
    '%LOCALAPPDATA%\GitHubDesktop\bin',
    'C:\opt\scoop\apps\llvm\current\bin',
    'C:\opt\scoop\apps\mpv\current',
    'C:\opt\scoop\apps\openssl\current\bin',
    'C:\opt\scoop\apps\postgresql\current\bin',

    '%LOCALAPPDATA%\Microsoft\WindowsApps',

    ''
)

$envpathMachineSnapshot = @(
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    '%SystemRoot%\System32\WindowsPowerShell\v1.0\',

    'C:\Program Files\PowerShell\7\',
    'C:\Program Files\dotnet\',
    '%SystemRoot%\System32\OpenSSH\',

    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\',

    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin',
    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\libnvvp',
    'C:\Program Files\NVIDIA Corporation\Nsight Compute 2023.1.1\',
    'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',

    'C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\DAL',
    'C:\Program Files\Intel\Intel(R) Management Engine Components\DAL',

    'C:\Program Files\Microsoft SQL Server\150\Tools\Binn\',
    'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\',

    ''
)

$includes = @(
    'traits-msft',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
