
function IsAbsPath([string]$s) {
    if ($s.StartsWith('/')) {
        return $true
    }
    if (($s.Length -gt 3) -and ($s.Substring(1, 2) -in @(":\", ":/"))) {
        return $true
    }
    return $false
}

function NormalizePath($filename) {
    $filename = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($filename)
    # $filename = (Resolve-Path $filename).

    # $lastSlash = $filename.EndsWith('\')
    # if (-not $lastSlash) {
    #     $filename += '\'
    # }

    # $filename = $filename -replace '\\(\.?\\)+', '\'

    # while ($filename -match '\\([^\\.]|\.[^\\.]|\.\.[^\\])[^\\]*\\\.\.\\') {
    #     $filename = $filename -replace '\\([^\\.]|\.[^\\.]|\.\.[^\\])[^\\]*\\\.\.\\', '\'
    # }

    # if (-not $lastSlash) {
    #     $filename = $filename.TrimEnd('\')
    # }

    return $filename
}
