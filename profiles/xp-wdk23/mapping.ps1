
# suffix '/' matters
$mapping = @(
    @('$($env:APPDATA)/Code/User/settings.json', 'programs/vscode/settings.json'),
    @('$($env:LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json', 'programs/WindowsTerminal/settings.json'),
    @()
)

$includes = @(
    'traits-home',
    'traits:devenv',
    'traits:wsl',
    'traits'
)
