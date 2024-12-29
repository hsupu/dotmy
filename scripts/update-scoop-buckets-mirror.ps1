<#
.NOTES
Install-Module -Scope CurrentUser Microsoft.PowerShell.ConsoleGuiTools
#>
param(
    [string]$Mirror
)

if ('' -eq $Mirror) {
    $Mirror = "https://mirror.ghproxy.com/github.com"
}

$config_SCOOP_REPO = scoop config SCOOP_REPO
Write-Host "Reset `"scoop config SCOOP_REPO`" $config_SCOOP_REPO"
scoop config SCOOP_REPO "$Mirror/ScoopInstaller/Scoop"

$known = @{
    "main" = "$Mirror/ScoopInstaller/Main";
    "extras" = "$Mirror/ScoopInstaller/Extras";
    "java" = "$Mirror/ScoopInstaller/Java";
    "portablesoft" = "$Mirror/shenbo/portablesoft";
    "scoopcn" = "$Mirror/scoopcn/scoopcn";
}

$buckets = scoop bucket list
$names = $buckets | % { $_.Name.ToLower() }
foreach ($kvp in $known.GetEnumerator()) {
    $index = $names.IndexOf($kvp.Key.ToLower())
    if (-1 -ne $index) {
        Write-Host "Reset bucket $($kvp.Key) $($buckets[$index].Source)"
        scoop bucket rm $kvp.Key
        scoop bucket add $kvp.Key $kvp.Value
    }
}

$buckets = scoop bucket list
$buckets
