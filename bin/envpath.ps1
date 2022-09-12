# WIP
param(
    [switch]$ForMachine
)

if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    Write-Error "Not in Windows OS"
    return
}

# $shorten = @{
#     ''
# }

# $users = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User)
# $machines = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)

# Write-Host $users

# Write-Host $machines

$keepTop = @(
    'C:\my\bin',
    'C:\my\local\gen\bin',
    'C:\my\scripts',
    "$($HOME)\.local\bin"
)

$keepBottom = @(
    "$($env:LOCALAPPDATA)\Microsoft\WindowsApps"
)

$remove = @(
    "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
)

function Normalize-Path($raw) {
    $local:paths = [System.Collections.Generic.List[string]]::new($raw -split ';')

    $local:index = 0
    foreach ($item in $script:keepTop) {
        if ([string]::IsNullOrEmpty($item)) {
            continue
        }
        $paths.Remove($item) | Out-Null
        $paths.Insert($index, $item) | Out-Null
        ++$index
    }

    foreach ($item in $script:keepBottom) {
        if ([string]::IsNullOrEmpty($item)) {
            continue
        }
        $paths.Remove($item) | Out-Null
        $paths.Add($item) | Out-Null
    }

    foreach ($item in $script:remove) {
        $paths.Remove($item) | Out-Null
    }

    return $paths
}

$paths = Normalize-Path ([System.Environment]::GetEnvironmentVariable('PATH',
    $ForMachine ? [System.EnvironmentVariableTarget]::Machine : [System.EnvironmentVariableTarget]::User))

$paths
