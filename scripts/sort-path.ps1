# WIP
param(
    [switch]$ForMachine,

    # Replace $HOME as "%USERPROFILE%"
    [switch]$UseVariable,

    [switch]$DryRun
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
    'C:\my\scripts',
    'C:\my\local\bin',
    "${HOME}\.local\bin",
    'C:\my\local\shims',
    "${env:SCOOP}\shims",
    "${env:SCOOP}\apps\gsudo\current",
    ""
)

$keepGroups = @()

$keepGroups.Add(@(
    "${HOME}\.cargo\bin",
    "${HOME}\go\bin",
    "${HOME}\.dotnet\tools",
    "${env:SCOOP}\pyenv\current\pyenv-win\shims",
    "${env:LOCALAPPDATA}\pnpm"
    "${env:NODE_PATH}",
    "${env:SCOOP}\apps\temurin17-jdk\current\bin",
    ""
)) | Out-Null

$keepGroups.Add(@(
    "${env:SCOOP}\apps\llvm\current\bin",
    "${env:SCOOP}\apps\qemu\current",
    "${env:SCOOP}\apps\postgresql\current\bin",
    "${env:SCOOP}\apps\mpv\current",
    ""
)) | Out-Null

$keepBottom = @(
    "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\bin",
    "${env:LOCALAPPDATA}\Microsoft\WindowsApps",
    ""
)

$toRemove = @(
    "${env:LOCALAPPDATA}\GitHubDesktop\bin",
    ""
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
