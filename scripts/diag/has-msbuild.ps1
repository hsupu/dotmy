
$value = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\12.0" -Name MSBuildToolsPath
if ($value -eq '') {
    Write-Error -ErrorAction Continue "MSBuild 2013 not installed. see http://www.microsoft.com/en-us/download/details.aspx?id=40760"
}
