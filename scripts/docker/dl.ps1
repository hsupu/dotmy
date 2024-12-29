
param(
    [string]$Version
)

$versionsUrl = "https://download.docker.com/win/static/stable/x86_64/"

# .zip
$availableVersions = Invoke-WebRequest -ErrorAction Stop -Uri $versionsUrl -UseBasicParsing | Select-Object -ExpandProperty Links | %{ $_.href -match 'docker' } | Select-Object -ExpandProperty href | Sort-Object -Descending
$availableVersions = ($availableVersions | Select-String -Pattern "docker-(\d+\.\d+\.\d+).+"  -AllMatches | Select-Object -Expand Matches | %{ $_.Groups[1].Value })
if ($availableVersions.Length -eq 0) {
    throw "No available versions"
}
Write-Host "Available versions:`n$($availableVersions)"

if ('' -eq $Version) {
    $Version = $availableVersions[0]
}
elseif ($availableVersions -notcontains $Version) {
    throw "Version not available: $Version"
}

$zipUrl = "$versionsUrl/docker-$Version.zip"
$zipPath = Join-Path $PWD "docker-$Version.zip"

Start-BitsTransfer -ErrorAction Stop -Source $zipUrl -Destination $zipPath
