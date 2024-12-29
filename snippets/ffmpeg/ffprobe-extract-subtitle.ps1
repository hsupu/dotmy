param(
    [Parameter(Mandatory)]
    [string]$In,

    [string]$Lang,

    [switch]$dummy
)

$ErrorActionPreference = 'Stop'
trap { throw $_ }

$ffprobeArgs = @(
    "-i", $In,
    "-show_streams",
    "-select_streams", "s",
    "-of", "json",
    "-loglevel", "warning"
)
$raw = $(& ffprobe.exe @ffprobeArgs) | Out-String

Write-Host $raw
