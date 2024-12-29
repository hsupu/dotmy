<#
.NOTES
nacos 会自动选择 bin 的上级目录作为 BaseDir
#>
param()

$startup = Join-Path $PSScriptRoot "dist-2.3.2\bin\startup.cmd"
& $startup -m standalone
if ($LASTEXITCODE -ne 0) {
    Write-Host "startup.cmd exited with $LASTEXITCODE"
    exit 1
}
