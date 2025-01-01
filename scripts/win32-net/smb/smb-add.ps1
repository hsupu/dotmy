param(
    [Parameter(Mandatory)]
    [string]$ShareName,

    [Parameter(Mandatory)]
    [string]$ShareRoot,

    [switch]$CurrentUserFullAccess,
    [switch]$EveryoneRead
)

& net share $ShareName /delete

$netArgs = @(
    "$ShareName=`"$ShareRoot`""
)
if ($CurrentUserFullAccess) {
    $netArgs += @("/grant:$($env:USER),full")
}
if ($EveryoneRead) {
    $netArgs += @("/grant:everyone,read")
}

& net share @netArgs
if (0 -ne $LASTEXITCODE) {
    throw "net.exe exited with code $LASTEXITCODE"
}
