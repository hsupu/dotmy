
function global:encoding() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        $InputObject,

        [System.Text.Encoding]$Encoding,

        [switch]$Decode,
        [switch]$DecodeAsString
    )

    if ($null -eq $Encoding) {
        $Encoding = [System.Text.Encoding]::UTF8
    }

    if ($Decode) {
        if ($InputObject -is [byte[]]) {
            $b = $InputObject
        }
        else {
            throw "InputObject must be string, got $($InputObject.GetType().FullName)"
        }

        $t = $Encoding.GetString($b)
        return Write-Output -NoEnumerate $t
    }
    else {
        if ($InputObject -is [string]) {
            $s = $InputObject
        }
        else {
            throw "InputObject must be string, got $($InputObject.GetType().FullName)"
        }

        $o = $Encoding.GetBytes($s)
        return Write-Output -NoEnumerate $o
    }
}

function global:hex() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        $InputObject,

        [switch]$Decode,
        [switch]$DecodeAsString
    )

    if ($Decode) {
        if ($InputObject -is [string]) {
            $s = $InputObject
        }
        elseif ($InputObject -is [byte[]]) {
            $s = [System.Text.Encoding]::UTF8.GetString($InputObject)
        }
        else {
            throw "InputObject must be string, got $($InputObject.GetType().FullName)"
        }

        $o = [System.Convert]::FromHexString($s)
        if ($DecodeAsString) {
            $t = [System.Text.Encoding]::UTF8.GetString($o)
            return Write-Output -NoEnumerate $t
        }
        else {
            return Write-Output -NoEnumerate $o
        }
    }
    else {
        if ($InputObject -is [string]) {
            $b = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
        }
        elseif ($InputObject -is [byte[]]) {
            $b = $InputObject
        }
        else {
            throw "InputObject must be string, got $($InputObject.GetType().FullName)"
        }

        $o = [System.Convert]::ToHexString($b)
        return Write-Output -NoEnumerate $o
    }
}

function global:base64() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        $InputObject,

        [switch]$Decode,
        [switch]$DecodeAsString
    )

    if ($Decode) {
        if ($InputObject -is [string]) {
            $s = $InputObject
        }
        elseif ($InputObject -is [byte[]]) {
            $s = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
        }
        else {
            throw "InputObject must be string, got $($InputObject.GetType().FullName)"
        }

        $o = [Convert]::FromBase64String($s)
        if ($DecodeAsString) {
            $t = [System.Text.Encoding]::UTF8.GetString($o)
            return Write-Output -NoEnumerate $t
        }
        else {
            return Write-Output -NoEnumerate $b
        }
    }
    else {
        if ($InputObject -is [string]) {
            $b = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
        }
        elseif ($InputObject -is [byte[]]) {
            $b = $InputObject
        }
        else {
            throw "InputObject must be either string or byte[], got $($InputObject.GetType().FullName)"
        }

        $o = [Convert]::ToBase64String($b)
        return Write-Output -NoEnumerate $o
    }
}
