param(
    [string]$ProcessName,
    [int]$Duration
)

$isAdmin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw "Requires to run as Administrator"
}

# https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.host.pshostuserinterface.promptforchoice?view=powershellsdk-7.2.0
# $choices = @("&Cancel", "&No", "&Aye", "&Yes")
# $choice = $Host.UI.PromptForChoice('xperf-start', 'Confirm to start xperf', $choices, -1)
# if ($choice -lt 2) {
#     Write-Host "Cancelled"
#     return
# }

if (![string]::IsNullOrEmpty($ProcessName)) {
    $SetIFEO = $true
    $ifeoEntry = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$ProcessName"
}

# IFEO 是为特定程序设置参数
if ($true -eq $SetIFEO) {
    Write-Host 'Adding the process to IFEO'
    # reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%1.exe" /v TracingFlags /t REG_DWORD /d 1 /f
    if (!(Test-Path -Path $ifeoEntry)) { New-Item -Path $ifeoEntry }
    Set-ItemProperty -Path $ifeoEntry -Name 'TracingFlags' -Value 1 -Type DWORD -Force | Out-Null
}

Write-Host 'set DisablePagingExecutive'
# reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /d 1 /t REG_DWORD /f
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'DisablePagingExecutive' -Value 1 -Type DWORD -Force | Out-Null

if (0 -eq $Duration) { $Duration = 10; }
Write-Host "xperf and sleep ${Duration}s"
& xperf -on Latency -stackwalk profile
Start-Sleep -Seconds $Duration

& xperf -d my.etl

if ($true -eq $SetIFEO) {
    Write-Host 'unset IFEO'
    # reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%1.exe" /v TracingFlags /f
    Remove-ItemProperty -Path $ifeoEntry -Name 'TracingFlags' -Force | Out-Null
}

Write-Host 'unset DisablePagingExecutive'
# reg delete "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /sv DisablePagingExecutive /f
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'DisablePagingExecutive' -Force | Out-Null

# xperf -on PROC_THREAD+LOADER+VIRT_ALLOC -BufferSize 16384 -MinBuffers 1024 -MaxBuffers 1024 -stackwalk VirtualAlloc
# xperf -start HeapSession -heap -pids 33712 -stackwalk HeapAlloc+HeapRealloc -BufferSize 16384 -MinBuffers 1024 -MaxBuffers 1024 -MaxFile 1024 -FileMode Circular
# echo Press a key when you want to stop...
# pause
# echo . 
# echo ...Stopping... 
# echo .
# xperf -stop HeapSession -stop -d heap-profile-0627_1600.etl

