
# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),

    @('$($env:LOCALAPPDATA)/JetBrains', 'C:/opt/JetBrains/Local/'),
    @('$($env:APPDATA)/JetBrains', 'C:/opt/JetBrains/Roaming/'),

    @()
)

$userEnv = @{
}

$envpathUserSnapshot = @(
    'C:\my\bin-work',
    'C:\my\bin',
    'C:\my\scripts',
    'C:\my\local\bin',
    # '%USERPROFILE\.local\bin',
    # 曾有 C:\my\local\gen\bin，不再使用，已并入 C:\my\bin-work

    'C:\opt\scoop\shims',

    '%LOCALAPPDATA%\pnpm', # %PNPM_HOME%
    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',
    '%USERPROFILE%\.dotnet\tools',
    'C:\opt\cargo\bin',
    'C:\opt\scoop\apps\nvm\current\nodejs\nodejs',
    'C:\opt\scoop\apps\pyenv\current\pyenv-win\bin',
    'C:\opt\scoop\apps\pyenv\current\pyenv-win\shims',
    'C:\opt\scoop\apps\temurin17-jdk\current\bin',

    'C:\opt\scoop\apps\imagemagick\current',
    'C:\opt\scoop\apps\postgresql\current\bin',

    '%LOCALAPPDATA%\Microsoft\WindowsApps',

    ''
)

$envpathMachineSnapshot = @(
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    'C:\Program Files\gsudo\Current',
    '%SystemRoot%\System32\WindowsPowerShell\v1.0\',

    'C:\Program Files\PowerShell\7\',
    'C:\Program Files\dotnet\',
    '%SystemRoot%\System32\OpenSSH\',

    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin',
    'C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\libnvvp',
    'C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common',

    'C:\Program Files\RedHat\Podman\',

    ''
)

$includes = @(
    'traits-msft',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
