param(
)

$srcRoot = "F:\良医 S1+S2+S3"
$dstRoot = Resolve-Path "."

$map = @{
}

foreach ($e in $map.GetEnumerator()) {
    $src = Join-Path $srcRoot $e.Key
    $dst = Join-Path $dstRoot "$($e.Value).mp4"
    if (Test-Path $dst) {
        continue
    }
    # 插入字幕
    # if (Test-Path $srt) {
    #     $txt = "subtitles=$srt"
    # }
    # elseif (Test-Path $ass) {
    #     $txt = "subtitles=$ass"
    # }
    # 缩放
    $txt = "scale=1920:1080"

    & ffmpeg -hwaccel dxva2 -i $src -c:v h264_amf -vf $txt -y $dst
}
