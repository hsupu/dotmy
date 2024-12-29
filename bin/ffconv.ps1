param(
    [Parameter(Mandatory, Position=0)]
    [string]$DstExt,

    [Parameter(Mandatory, Position=1)]
    [string]$Src,

    [switch]$DownMix,

    [switch]$DryRun
)

# -b : 指定 比特率 [video+audio]
# -q : 指定 VBR 级别 0-5
# -vn : no video
# -acodec : 指定 audio codec
# -ab : 指定 audio 比特率 in bps
# -ar : 指定 audio 采样率 in Hz

# flac codec
# -compression_level : 压缩级别 0-12 默认=5

$items = Get-Item -Path $Src
if (0 -eq $items.Count) {
    $items = Get-Item -LiteralPath $Src
}
Write-Host "Found $($items.Count) : $Src"

foreach ($item in $items) {
    if (@("mp3") -icontains $DstExt) {
        # 默认写入 ID3v2.4，如需 -id3v2_version 3
        & ffmpeg.exe -i $item.FullName -vn -ab 320k -map_metadata 0 "$($item.BaseName).$DstExt"
    }
    elseif (@("m4a") -icontains $DstExt) {
        & ffmpeg.exe -i $item.FullName -vn -q 4 -map_metadata 0 "$($item.BaseName).$DstExt"
    }
    elseif (@("ape") -icontains $DstExt) {
        & ffmpeg.exe -i $item.FullName -vn -acodec ape "$($item.BaseName).$DstExt"
    }
    elseif (@("flac") -icontains $DstExt) {
        if ($DownMix) {
            # https://superuser.com/questions/852400/properly-downmix-5-1-to-stereo-using-ffmpeg
            # 如果默认音量小，可以自定义混音公式
            # -af "pan=stereo|c0=c2+0.30*c0+0.30*c4|c1=c2+0.30*c1+0.30*c5"
            & ffmpeg.exe -i $item.FullName -vn -c:a dca -ac 2 "$($item.BaseName).$DstExt"
        }
        else {
            & ffmpeg.exe -i $item.FullName -vn "$($item.BaseName).$DstExt"
        }
    }
    else {
        & ffmpeg.exe -i $item.FullName -vn "$($item.BaseName).$DstExt"
    }
}
