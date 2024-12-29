param(
    [Parameter(Mandatory, Position=0, ValueFromPipeline)]
    [string]$InputObject,

    [string]$Encoding = "UTF-8",

    [switch]$Encode
)

$encoding = [System.Text.Encoding]::GetEncoding($Encoding)

if ($Encode) {
    [System.Web.HttpUtility]::UrlEncode($InputObject, $encoding)
}
else {
    [System.Web.HttpUtility]::UrlDecode($InputObject, $encoding)
}
