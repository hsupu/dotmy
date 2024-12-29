<#
.DESCRIPTION
目前只使用了 base.js，且写死了监听在 http://127.0.0.1:4002/pac.js
#>
param()

Push-Location $PSScriptRoot
try {
    $env:CADDY_FILE_DIR = $PSScriptRoot
    & caddy run .\Caddyfile
}
finally {
    Pop-Location
}
