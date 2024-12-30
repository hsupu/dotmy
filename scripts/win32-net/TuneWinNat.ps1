
$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

$hklmWinNat = "HKLM:\SYSTEM\CurrentControlSet\Services\WinNat"

# 批量预留端口的数量，重启生效；如果提示端口被 System 占用，可以试试改小
GetSetRegValue $hklmWinNat "PortChunkSize" 100 "DWORD"

# UDP 会话超时（秒），重启生效
GetSetRegValue $hklmWinNat "UdpSessionTimeout" 30 "DWORD"

Restart-Service WinNat
