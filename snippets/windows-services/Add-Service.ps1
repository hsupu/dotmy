$name = ""
$displayName = ""
$path = ""
$desc = ""

# Automatic, Manual, Disabled, AutomaticDelayedStart, InvalidValue
$boot = "Manual"

New-Service \
    -Name $name \
    -DisplayName $displayName \
    -Description $desc \
    -StartupType $boot \
    -BinaryPathName $path
