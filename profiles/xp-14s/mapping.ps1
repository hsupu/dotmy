
# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @()
)

$userEnv = @{
}

$envpathUserSnapshot = @(
    'C:\opt\scoop\apps\gsudo\current',
    'C:\my\bin',
    '%USERPROFILE\.local\bin', # 'C:\my\local\bin',

    'C:\opt\scoop\shims',
    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',

    # dotnet
    '%USERPROFILE%\.dotnet\tools',
    # go
    # '%USERPROFILE%\go\bin',
    # java
    # 'C:\opt\scoop\apps\temurin17-jdk\current\bin',
    # 'C:\opt\scoop\apps\maven\current\bin',
    # js
    # '%PNPM_HOME%',
    # 'C:\opt\scoop\apps\nvm\current\nodejs\nodejs',
    # py
    # 'C:\opt\scoop\apps\pyenv\current\pyenv-win\shims',
    # rust
    'C:\opt\cargo\bin',

    '%LOCALAPPDATA%\GitHubDesktop\bin',
    'C:\opt\scoop\apps\openssl\current\bin',
    '%LOCALAPPDATA%\Microsoft\WindowsApps',

    ''
)

$envpathMachineSnapshot = @(
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    '%SystemRoot%\System32\WindowsPowerShell\v1.0\',

    'C:\Program Files\PowerShell\7\',
    # 'C:\Program Files (x86)\dotnet-core-uninstall\',
    'C:\Program Files\dotnet\',
    '%SystemRoot%\System32\OpenSSH\',

    'C:\Program Files\Microsoft SQL Server\130\Tools\Binn\',

    ''
)

$includes = @(
    'traits-home',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
