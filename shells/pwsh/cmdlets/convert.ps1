# https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/adding-parameters-that-process-pipeline-input?view=powershell-7.2
# https://stackoverflow.com/questions/17474131/creating-byte-in-powershell
# https://stackoverflow.com/questions/24708859/output-binary-data-on-powershell-pipeline
# https://github.com/PowerShell/PowerShell/issues/1908
param(
    [switch]$MyDebug
)

return

function ConvertFrom-Hex() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $InputObject"
    }

    if ([string]::IsNullOrEmpty($InputObject)) {
        return
    }

    $rb = [System.Convert]::FromHexString($InputObject)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $($rb.Length): $rb"
    }
    $r = [System.IO.MemoryStream]::new()
    $r.Write($rb, 0, $rb.Length) | Out-Null
    return $r
}

function ConvertTo-Hex() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [System.IO.Stream]$InputObject,

        [switch]$MyDebug
    )
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $($InputObject.Length): $sb"
    }

    if (($null -eq $InputObject) -or ($InputObject.Length -eq 0)) {
        return
    }

    $InputObject.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
    $sb = [byte[]]::new($InputObject.Length)
    $InputObject.Read($sb, 0, $sb.Length) | Out-Null

    $r = [System.Convert]::ToHexString($sb)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $r"
    }
    return $r
}

function ConvertFrom-Base64() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $InputObject"
    }

    if ([string]::IsNullOrEmpty($InputObject)) {
        return
    }

    $rb = [System.Convert]::FromBase64String($InputObject)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $($rb.Length): $rb"
    }
    $r = [System.IO.MemoryStream]::new()
    $r.Write($rb, 0, $rb.Length) | Out-Null
    return $r
}

function ConvertTo-Base64() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [System.IO.Stream]$InputObject,

        [switch]$MyDebug
    )
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $($InputObject.Length): $sb"
    }

    if (($null -eq $InputObject) -or ($InputObject.Length -eq 0)) {
        return
    }

    $InputObject.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
    $sb = [byte[]]::new($InputObject.Length)
    $InputObject.Read($sb, 0, $sb.Length) | Out-Null

    $r = [System.Convert]::ToBase64String($sb)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $r"
    }
    return $r
}

function ConvertFrom-UTF8() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [System.IO.Stream]$InputObject,

        [switch]$MyDebug
    )
    if ($null -eq $InputObject) {
        return
    }

    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $($InputObject.Length) $sb"
    }

    if (($null -eq $InputObject) -or ($InputObject.Length -eq 0)) {
        return
    }

    $InputObject.Seek(0, [System.IO.SeekOrigin]::Begin) | Out-Null
    $sb = [byte[]]::new($InputObject.Length)
    $InputObject.Read($sb, 0, $sb.Length) | Out-Null

    $r = [System.Text.Encoding]::UTF8.GetString($sb)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $r"
    }
    return $r
}

function ConvertTo-UTF8() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) enter $InputObject"
    }

    if ([string]::IsNullOrEmpty($InputObject)) {
        return
    }

    $rb = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
    if ($MyDebug) {
        Write-Host "$($MyInvocation.MyCommand) leave $($rb.Length): $rb"
    }
    $r = [System.IO.MemoryStream]::new()
    $r.Write($rb, 0, $rb.Length) | Out-Null
    return $r
}

function ConvertFrom-HexString() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    $r = ConvertFrom-Hex $InputObject -MyDebug:$MyDebug | ConvertFrom-UTF8 -MyDebug:$MyDebug
    return $r
}

function ConvertTo-HexString() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    $r = ConvertTo-UTF8 $InputObject -MyDebug:$MyDebug | ConvertTo-Hex -MyDebug:$MyDebug
    return $r
}

function ConvertFrom-Base64String() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    $r = ConvertFrom-Base64 $InputObject -MyDebug:$MyDebug | ConvertFrom-UTF8 -MyDebug:$MyDebug
    return $r
}

function ConvertTo-Base64String() {
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$InputObject,

        [switch]$MyDebug
    )
    $r = ConvertTo-UTF8 $InputObject -MyDebug:$MyDebug | ConvertTo-Base64 -MyDebug:$MyDebug
    return $r
}
