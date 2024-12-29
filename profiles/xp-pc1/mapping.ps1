
# suffix '/' matters
$mapping = @(
    # @('$($env:APPDATA)/Code/User/profiles/-b8732d0/extensions.json', 'programs/vscode/extensions.json'),
    # @('$($env:APPDATA)/Code/User/profiles/-b8732d0/keybindings.json', 'programs/vscode/keybindings.json'),
    # @('$($env:APPDATA)/Code/User/profiles/-b8732d0/settings.json', 'programs/vscode/settings.json'),
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @()
)

$userEnv = @{
}

$envpathUserSnapshot = @(
    'C:\opt\scoop\apps\gsudo\current',
    'C:\my\bin',
    '%USERPROFILE%\.local\bin', # 'C:\my\local\bin',

    'C:\opt\scoop\shims',
    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',

    # 'C:\opt\scoop\apps\pyenv\current\pyenv-win\bin', # pyenv, but has bat on scoop\shims
    # 'C:\opt\scoop\apps\nvm\current', # nvm, created shim on local\bin

    '%USERPROFILE%\.dotnet\tools', # installed "dotnet tools"
    'C:\opt\scoop\apps\pyenv\current\pyenv-win\shims', # python pip etc.
    '%LOCALAPPDATA%\Programs\Python\Launcher\' # py pyw
    '%PNPM_HOME%', # pnpm and global pkgs
    'C:\opt\scoop\apps\nvm\current\nodejs\nodejs', # node npm etc.
    'C:\opt\scoop\apps\temurin17-jdk\current\bin',
    'C:\opt\scoop\apps\maven\current\bin',
    'C:\opt\cargo\bin', # rustup rustc cargo rls etc.
    '%USERPROFILE%\go\bin',

    '%LOCALAPPDATA%\GitHubDesktop\bin',
    'C:\opt\scoop\apps\imagemagick\current\bin',
    'C:\opt\scoop\apps\llvm\current\bin',
    'C:\opt\scoop\apps\mpv\current\bin',
    'C:\opt\scoop\apps\postgresql\current\bin',
    'C:\opt\scoop\apps\qemu\current\bin',

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

    # '%ProgramData%\chocolatey\bin',
    '%ProgramData%\scoop\shims',

    'C:\Program Files (x86)\VMware\VMware Workstation\bin\',

    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin',
    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\libnvvp',
    'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',

    'C:\Program Files\Microsoft SQL Server\130\Tools\Binn\',

    ''
)

$includes = @(
    'traits-home',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
