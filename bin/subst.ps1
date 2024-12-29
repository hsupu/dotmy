param(
    [string]$DriveLetter,
    [string]$Path
)

& subst.exe "$($DriveLetter):" (Resolve-Path -LiteralPath $Path)
