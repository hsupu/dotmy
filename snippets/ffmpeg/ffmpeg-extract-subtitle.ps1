param(
)

$srcRoot = "F:\良医 S1+S2+S3"
$dstRoot = Resolve-Path "."

$map = @{
}

foreach ($e in $map.GetEnumerator()) {
    $src = Join-Path $srcRoot $e.Key
    $dst = Join-Path $dstRoot "$($e.Value).srt"
    if (Test-Path $dst) {
        continue
    }
    & ffmpeg -i $src -map "0:19" -y $dst
}
