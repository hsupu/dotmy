
Push-Location $PSScriptRoot
try {
    # run - run in foreground
    # start - run in background
    # --adapter caddyfile
    & caddy run
}
finally {
    Pop-Location
}
