
$ErrorActionPreference = "Stop"
trap { throw $_ }

. (Join-Path $env:DOTMY "scripts/_lib/RegOp.ps1")

# Diagnostic and usage data
# 0 - never, 1 - basic, 2 - enhanced, 3 - full
GetSetRegValue $hklmPoliciesDataCollection "AllowTelemetry" 0 "DWORD"
GetSetRegValue $hklmWCVPoliciesDataCollection "AllowTelemetry" 0 "DWORD"
GetSetRegValue $hklmWow6432WCVPoliciesDataCollection "AllowTelemetry" 0 "DWORD"

# AD customization
GetSetRegValue $hklmPoliciesAdvertisingInfo "DisabledByGroupPolicy" 1 "DWORD"
GetSetRegValue $hklmPoliciesAdvertisingInfo "Enabled" 0 "DWORD"

# Customer Experience Improvement Program
GetSetRegValue $hklmPoliciesSQMClientWindows "CEIPEnable" 0 "DWORD"

# Application Impact Telemetry
GetSetRegValue $hklmPoliciesAppCompat "AITEnable" 0 "DWORD"

# If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds")) {
#     New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Force | Out-Null
# }
