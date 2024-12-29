param(
    [string]$RootDir
)

$RootDir = Resolve-Path $RootDir

# please try the following line before use this!
& icacls.exe $RootDir /grant "${env:USER}:F"
