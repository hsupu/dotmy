param(
    [switch]$Enable,
    [switch]$LocalMachine
)

if ($Enable) {
    if ($LocalMachine) {
        $regKey = 'HKLM:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
    }
    else {
        $regKey = 'HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
    }
    New-Item -Path $key -Force | Out-Null
    New-ItemProperty -Path $key -Name '(default)' -Value '' -PropertyType String -Force | Out-Null
}
else {
    if ($LocalMachine) {
        $regKey = 'HKLM:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
    }
    else {
        $regKey = 'HKCU:\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
    }
    Remove-Item -Path $regPath -Recurse -Force
}

return

# 旧方法
@"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\586118283]
"EnabledState"=dword:00000001
"EnabledStateOptions"=dword:00000001
"Variant"=dword:00000000
"VariantPayload"=dword:00000000
"VariantPayloadKind"=dword:00000000
"@
