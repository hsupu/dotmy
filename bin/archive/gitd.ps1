param(
    [Parameter(Position=0)]
    [string]$Root
)

if ([string]::IsNullOrEmpty($Root)) {
    $Root = "."
}

# --enable=upload-pack
& git daemon --enable=receive-pack --reuseaddr --verbose --base-path=$Root
