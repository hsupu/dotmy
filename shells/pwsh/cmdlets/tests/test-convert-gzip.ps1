param()

trap {
    $_
    $_.ScriptStackTrace
    return
}

. (Join-Path $PSScriptRoot "../convert-base64.ps1")
. (Join-Path $PSScriptRoot "../convert-gzip.ps1")

Write-Host "base64"
base64 ( `
    base64 "aa"
) -Decode -DecodeAsString

Write-Host "gzip"
gzip ( `
    gzip "aa" `
) -Decode -DecodeAsString

Write-Host "base64 | gzip"
base64 ( `
    gzip ( `
        gzip ( `
            base64 "aa" `
        ) `
    ) -Decode -DecodeAsString `
) -Decode -DecodeAsString

Write-Host "gzip | base64"
gzip ( `
    base64 ( `
        base64 ( `
            gzip "aa" `
        ) `
    ) -Decode `
) -Decode -DecodeAsString
