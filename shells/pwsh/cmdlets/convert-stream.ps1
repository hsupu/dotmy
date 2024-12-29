
function ConvertTo-Stream() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [byte[]]$InputObject
    )
    $out = [System.IO.MemoryStream]::new()
    $out.Write($InputObject, 0, $InputObject.Length) | Out-Null
    return $out
}

function ConvertFrom-Stream() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [System.IO.Stream]$InputObject,

        [switch]$NoRewind
    )
    if ($null -eq $InputObject) {
        return
    }
    $b = [byte[]]::new($InputObject.Length)
    if (-not $NoRewind) {
        $InputObject.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
    }
    $InputObject.Read($b, 0, $b.Length) | Out-Null
    return Write-Output -NoEnumerate $b
}
