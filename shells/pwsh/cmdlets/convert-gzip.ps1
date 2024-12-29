
function global:gzip() {
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        $InputObject,

        [switch]$Decode,
        [switch]$DecodeAsString
    )

    if ($Decode) {
        if ($InputObject -is [byte[]]) {
            $b = $InputObject
        }
        elseif ($InputObject -is [array]) {
            if ($InputObject.Length -eq 0) {
                throw "InputObject must be byte[], got $($InputObject.GetType().GetElementType().FullName)[0]"
            }
            else {
                throw "InputObject must be byte[], got $($InputObject[0].GetType().FullName)[$($InputObject.Length)]"
            }
        }
        else {
            throw "InputObject must be byte[], got $($InputObject.GetType().FullName)"
        }

        $outMemStream = [System.IO.MemoryStream]::new()
        try {
            $inMemStream = [System.IO.MemoryStream]::new($b)
            $flags = [IO.Compression.CompressionMode]::Decompress
            $gzipStream = [System.IO.Compression.GzipStream]::new($inMemStream, $flags, $false)
            try {
                $gzipStream.CopyTo($outMemStream) | Out-Null
            }
            finally {
                $gzipStream.Dispose() | Out-Null
                $gzipStream = $null
                $inMemStream.Dispose() | Out-Null
                $inMemStream = $null
            }
            $o = $outMemStream.ToArray()
            Write-Debug "gzip cbEncoded=$($b.Length) cbDecoded=$($o.Length)"
            if ($DecodeAsString) {
                return [System.Text.Encoding]::UTF8.GetString($o)
            }
            else {
                return Write-Output -NoEnumerate $o
            }
        }
        finally {
            $outMemStream.Dispose() | Out-Null
            $outMemStream = $null
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

        $outMemStream = [System.IO.MemoryStream]::new()
        try {
            $flags = [IO.Compression.CompressionMode]::Compress
            $gzipStream = [System.IO.Compression.GzipStream]::new($outMemStream, $flags, $false)
            try {
                $gzipStream.Write($b, 0, $b.Length) | Out-Null
            }
            finally {
                $gzipStream.Dispose() | Out-Null
                $gzipStream = $null
            }
            $o = $outMemStream.ToArray()
            Write-Debug "gzip cbPlain=$($b.Length) cbEncoded=$($o.Length)"
            return Write-Output -NoEnumerate $o
        }
        finally {
            $outMemStream.Dispose() | Out-Null
            $outMemStream = $null
        }
    }
}
