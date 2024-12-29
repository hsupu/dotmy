<#
.LINK
http://stackoverflow.com/questions/199080/how-to-detect-what-net-framework-versions-and-service-packs-are-installed
#>
param(
    [switch]$CheckForClient
)

# 3.5

$path = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5"

$value = Get-ItemPropertyValue -Path $path -Name Install
if ($value -ne '1') {
    Write-Error -ErrorAction Continue ".NET Framework 3.5 not installed. see http://www.microsoft.com/downloads/details.aspx?FamilyID=ab99342f-5d1a-413d-8319-81da479ab0d7"
}

# 4.0

if ($CheckForClient) {
    $path = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client"
} else {
    $path = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
}

$value = Get-ItemPropertyValue -Path $path -Name Install
if ($value -ne '1') {
    Write-Error -ErrorAction Continue ".NET Framework 4.0 not installed. see http://www.microsoft.com/downloads/en/details.aspx?FamilyID=9cfb2d51-5ff4-4491-b0e5-b386f32c0992"
}

# 4.5

$value = Get-ItemPropertyValue -Path $path -Name Release
# 5c615 is hex for 378389 decimal, which is the release number for .NET 4.5.1
if ($value -ne '5c615') {
    Write-Error -ErrorAction Continue ".NET Framework 4.5.1 not installed. see http://www.microsoft.com/en-us/download/details.aspx?id=40779"
}
