#!/usr/bin/env pwsh

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $path
)

$url = "https://github.com/$path/releases/latest"
$headers = [Collections.Generic.Dictionary[string, string]]::new()
$headers["Accept"] = "application/json"
try {
    $response = Invoke-WebRequest -Method 'GET' -Uri $url -Headers $headers
    $json = $response.Content | ConvertFrom-Json -AsHashtable
}
catch {
    Write-Error $_.Exception
	return ""
}

return $json["tag_name"]
