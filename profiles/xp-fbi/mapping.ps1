
# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @()
)

# updated 241111
$envpathUserSnapshot = @(
    'C:\opt\scoop\apps\gsudo\current',
    'C:\my\bin',
    '%USERPROFILE%\.local\bin', # 'C:\my\local\bin',

    'C:\opt\scoop\shims',
    '%LOCALAPPDATA%\Programs\Microsoft VS Code\bin',

    '%USERPROFILE%\.dotnet\tools', # installed "dotnet tools"
    # 'C:\opt\scoop\apps\pyenv\current\pyenv-win\bin', # pyenv, created shim on local\bin
    'C:\opt\scoop\apps\pyenv\current\pyenv-win\shims', # python pip etc.
    # 'C:\opt\scoop\apps\nvm\current', # nvm, created shim on local\bin
    '%PNPM_HOME%', # pnpm and global pkgs
    'C:\opt\scoop\apps\nvm\current\nodejs\nodejs', # node npm etc.
    'C:\opt\scoop\apps\temurin21-jdk\current\bin',

    'C:\opt\scoop\apps\postgresql\current\bin',

    '%LOCALAPPDATA%\Microsoft\WindowsApps',

    ''
)

# updated 241111
$envpathMachineSnapshot = @(
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    '%SystemRoot%\System32\WindowsPowerShell\v1.0\',
    '%SystemRoot%\System32\OpenSSH\',

    'C:\Program Files\dotnet\',
    'C:\Program Files\PowerShell\7\',

    # '%ProgramData%\scoop\shims',

    'C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\',

    'C:\Program Files\Microsoft SQL Server\150\Tools\Binn\',
    'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\',

    ''
)

$includes = @(
    'traits-home',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
