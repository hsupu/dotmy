
Write-Host "支持唤醒功能的外设"
& powercfg -devicequery wake_programmable

Write-Host "启用唤醒功能的外设"
& powercfg -devicequery wake_armed

Write-Host "唤醒计时器（计划任务）"
& powercfg -waketimers

Write-Host "上次唤醒"
& powercfg -lastwake

Write-Host "按需：开关唤醒功能"
Write-Host "& powercfg -deviceenablewake ""Device Name"""
Write-Host "& powercfg -devicedisablewake ""Device Name"""

Write-Host "当前的电源需求"
& powercfg -requests

Write-Host "按需：覆写电源需求"
Write-Host "& powercfg -requestsoverride PROCESS ""chrome.exe"" SYSTEM"
Write-Host "& powercfg -requestsoverride SERVICE ""spoolsv.exe"" SYSTEM"
# e.g. [DRIVER] Realtek High Definition Audio (HDAUDIO\FUNC_01&VEN_10EC&DEV_0295&SUBSYS_103C84DA&REV_1000\4&306c1263&0&0001)
Write-Host "& powercfg -requestsoverride DRIVER ""Driver Name"" SYSTEM"

Write-Host "按需：还原电源需求"
Write-Host "& powercfg -requestsoverride PROCESS ""chrome.exe"""

Write-Host "按需：电池使用报告"
Write-Host "& powercfg -batteryreport"
