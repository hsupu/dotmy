param(
    [Parameter(Mandatory)]
    [string[]]$Dirs
)

& czkawka dup -d @Dirs
