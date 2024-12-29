param(
  [switch]$NoPrintAdapt,
  [switch]$NoPrintCurrentConfig,
  [switch]$NoPrintNewConfig,
  [switch]$Apply
)

Push-Location $PSScriptRoot
try {
    & caddy validate --adapter caddyfile --config ./Caddyfile
    if ($LASTEXITCODE -ne 0) {
        throw "caddy validate exited with code $LASTEXITCODE"
    }

    $raw_adapted = & caddy adapt --adapter caddyfile --config ./Caddyfile

    if (-not $NoPrintAdapt) {
        Write-Host "Caddyfile.JSON"
        Write-Host $raw_adapted
        if ($LASTEXITCODE -ne 0) {
            throw "caddy adapt exited with code $LASTEXITCODE"
        }
    }

    # & curl -X GET "http://localhost:2019/config/"
    # if ($LASTEXITCODE -ne 0) {
    #     throw "curl GET /config exited with code $LASTEXITCODE"
    # }

    $currentConfigCO = Invoke-RestMethod -Method Get -Uri "http://localhost:2019/config/"

    if (-not $NoPrintCurrentConfig) {
        Write-Host "GET localhost:2019/config/"
        ConvertTo-Json $currentConfigCO -Compress -Depth 100 | Out-Host
    }

    $currentConfig = ConvertTo-Json -Depth 100 $currentConfigCO | ConvertFrom-Json -AsHashtable
    # $currentConfig = $currentConfigCO.PSObject.properties | ForEach-Object -Begin { $h = @{} } -End { $h } -Process {
    #     $h[$_.Name] = $_.Value
    # }

    $adapted = ConvertFrom-Json $raw_adapted -AsHashtable

    $newConfig = $currentConfig

    # Add-Member -InputObject $newConfig.apps.http.servers -TypeName NoteProperty -Name "r3is_front" -Value $adapted.apps.http.servers.r3is_front -PassThru
    $newConfig['apps']['http']['servers']['r3is_front'] = $adapted['apps']['http']['servers']['r3is_front']
    $newConfig['logging']['logs']['log_r3is_front'] = $adapted['logging']['logs']['log_r3is_front']

    # in case we switched the debug directive
    $newConfig['logging']['logs']['default'] = $adapted['logging']['logs']['default']

    if (-not $NoPrintNewConfig) {
        Write-Host "New Config"
        ConvertTo-Json $newConfig -Compress -Depth 100 | Out-Host
    }

    if (-not $Apply) {
        return
    }

    # & curl -X POST "http://localhost:2019/load" `
    #     -H "Content-Type: text/caddyfile" `
    #     --data-binary "`@Caddyfile"
    # if ($LASTEXITCODE -ne 0) {
    #     throw "curl POST /load exited with code $LASTEXITCODE"
    # }

    Invoke-RestMethod -Method Post -Uri "http://localhost:2019/load" `
        -ContentType "application/json" `
        -Body (ConvertTo-Json $newConfig -Compress -Depth 100)
}
finally {
    Pop-Location
}
