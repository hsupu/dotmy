
$regKeyWinNat = "HKLM:\SYSTEM\CurrentControlSet\Services\WinNat"

# 批量预留端口的数量，重启生效；如果提示端口被 System 占用，可以试试改小
New-ItemProperty -LiteralPath $regKeyWinNat -Name "PortChunkSize" -Value 1000 -PropertyType "Dword"

# UDP 会话超时（秒），重启生效
New-ItemProperty -LiteralPath $regKeyWinNat -Name "UdpSessionTimeout" -Value 30 -PropertyType "Dword"
