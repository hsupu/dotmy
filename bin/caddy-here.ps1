param(
    [Parameter(Position=0)]
    [string]$Path,

    [string]$HostAddress,
    [switch]$LocalHost,
    [switch]$AnyV6,

    [int]$Port
)

if ([string]::IsNullOrEmpty($Path)) {
    $Path = "."
}
$Path = Resolve-Path -LiteralPath $Path

if ([string]::IsNullOrEmpty($HostAddress)) {
    if ($LocalHost) {
        $HostAddress = "localhost"
    }
    elseif ($AnyV6) {
        $HostAddress = "[::]"
    }
    else {
        $HostAddress = "0.0.0.0"
    }
}

if (0 -eq $Port) {
    $Port = 40000
}

& caddy file-server --browse `
    --listen "${HostAddress}:${Port}" --root $Path `
    --access-log `
    @args
