param()

$apps = scoop list
foreach ($app in $apps) {
    $base = "$($app.Name) $($app.Version) [$($app.Source)]"
    $cmt = if (0 -lt $app.Info.Length) { " // $($app.Info)" } else { "" }
    Write-Host "$base$cmt"
}
