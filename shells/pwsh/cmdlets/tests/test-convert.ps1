
. (Join-Path $PSScriptRoot "../convert.ps1")

$cmdstr = $MyInvocation.Line.Substring($MyInvocation.OffsetInLine - 1)
if (-not ($cmdstr.StartsWith(". "))) {
    # direct run - local test
    Write-Host $cmdstr
    "Hello" | ConvertTo-HexString -MyDebug:$MyDebug | ConvertFrom-HexString -MyDebug:$MyDebug
    "Hello" | ConvertTo-Base64String -MyDebug:$MyDebug | ConvertFrom-Base64String -MyDebug:$MyDebug
}
