param()

Write-Host "pwsh $($PSVersionTable.PSVersion)"

# if dotnet fx >= 4.6, it returns fixed
# 4.0.30319.42000
#
Write-Host "dotnet $([System.Environment]::Version)"

# if PSReadLine installed, we get wrong assembly by non-qualified name
# > [Reflection.Assembly]::GetAssembly([System.Runtime.InteropServices.RuntimeInformation]).FullName
# Microsoft.PowerShell.PSReadLine, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35
#
Write-Host "desc $([System.Runtime.InteropServices.RuntimeInformation, mscorlib, PublicKeyToken=b77a5c561934e089]::FrameworkDescription)"

# if pwsh >= 7, it returns
# Anonymously Hosted DynamicMethods Assembly, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null
#
# convert semver to version to resolve override conflict
# https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.semanticversion?view=powershellsdk-7.3.0
#
# if (([version]$PSVersionTable.PSVersion).CompareTo([version]::Parse("7.0")) -lt 0) {
#     Write-Host "dotnetRuntimeAssembly $([System.Reflection.Assembly]::GetExecutingAssembly().ImageRuntimeVersion)"
# }
