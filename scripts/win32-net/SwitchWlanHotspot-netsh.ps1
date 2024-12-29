param(
    [string]$SSID,
    [string]$Pass,

    [switch]$Stop,
    [switch]$Disable
)

if ($Disable) {
    & netsh wlan set hostednetwork mode=disallow
    return
}

if ([string]::IsNullOrEmpty($SSID) -and [string]::IsNullOrEmpty($Pass)) {
    # nop
}
elseif ([string]::IsNullOrEmpty($SSID) -or [string]::IsNullOrEmpty($Pass)) {
    Write-Error "Must set -SSID and -Pass" -ErrorAction Stop
}
else {
    # 注意密码长度必须 ≥8
    & netsh wlan set hostednetwork mode=allow ssid="$SSID" key="$Pass"
}

if (-not $Stop) {
    & netsh wlan start hostednetwork
    Write-Host "请到 网络设置 里配置，共享其他的连接"
}
else {
    & netsh wlan stop hostednetwork
}
