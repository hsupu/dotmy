param(
    [switch]$RefreshDns,
    [switch]$RenewIpv4,
    [switch]$RenewIpv6
)

if ($RefreshDns) {
    & ipconfig /displaydns  # 查看 DNS 记录
    & ipconfig /flushdns    # 刷新 DNS 记录
}

if ($RenewIpv4) {
    & ipconfig /release      # 释放当前 IP
    & ipconfig /renew        # 重新申请 IP
}

if ($RenewIpv6) {
    & ipconfig /release6     # 释放当前 IP
    & ipconfig /renew6       # 重新申请 IP
}
