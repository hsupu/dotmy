param(
    [string] $baseUrl = '',
    [string] $changeId,
    [string] $buildQueue = '',
    [string] $buildId,
    [bool] $success
);

$dropUrl = '{0}/{1}/{2}' -f @($baseUrl, $changeId, $buildId);
$json = @{
    text = "build {0}" -f @( if ($success) { 'success' } else { 'failed' } );
    markdown = $true;
    user = 'tridays';
    attachments = @(
        @{
            title = 'drop';
            url = 'https://b/{0}?bq={1}' -f @($buildId, $buildQueue);
            text = '[{0}]({0})' -f @($dropUrl);
            color = $(if ($success) { '#0000ff' } else { '#ff0000' });
            images = @(
                # @{ url = ''; }
            );
        }
    );
};

$hookUrl = "https://hook.bearychat.com/=bwEDf/incoming/42825ff492c9520ad0a737a6e2b0429b"
$body = $json | ConvertTo-Json
try {
    $response = Invoke-WebRequest -Method 'POST' -Uri $hookUrl -ContentType 'application/json;charset=UTF-8' -Body $body
} catch {
    Write-Error $_.ErrorDetails.Message
}
