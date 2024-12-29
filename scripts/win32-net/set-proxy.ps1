<#
.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.4#-proxy

.NOTES
System.Net. WebRequest, HttpWebRequest, ServicePoint, and WebClient is replaced by HttpClient since pwsh 6.0

[System.Net.Http.HttpClient]::DefaultProxy 会关注如下环境变量：
HTTP_PROXY  – proxy for HTTP requests
HTTPS_PROXY — proxy for HTTPS requests
ALL_PROXY   – proxy for both HTTP and HTTPS
NO_PROXY    – proxy exclusion address list
#>
param(
    [Parameter(Position=0)]
    [string]$Url,

    [switch]$SetWinINet,
    [switch]$SetWinHttpCurrentSession,
    [switch]$SetWinHttpGlobally,
    [switch]$SetNetCore
)

function NewProxy
{
    if ('' -eq $Url) {
        return $null
    }

    $proxy = [System.Net.WebProxy]::new($Url)
    # NT Credential
    # $proxy.Credentials = Get-Credential
    # $proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    $proxy.BypassProxyOnLocal = $true
    $proxy.IsBypassed((& hostname))
    return $proxy
}

# WinHTTP 包含 HTTP server/client 实现，相比之下 WinINet 只用于 client 端，且部分操作可能弹出 GUI。
# https://learn.microsoft.com/en-us/windows/win32/wininet/wininet-vs-winhttp
if ($SetWinINet) {
    $hkcuWCVInternetSettings = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

    # list direct name-values
    & reg query $hkcuWCVInternetSettings /k * /d

    Set-ItemProperty -Path $hkcuWCVInternetSettings -name 'ProxyEnable' -value 1
    Set-ItemProperty -Path $hkcuWCVInternetSettings -name 'ProxyServer' -value $Url
    Set-ItemProperty -Path $hkcuWCVInternetSettings -name 'ProxyUser' -value ""
    Set-ItemProperty -Path $hkcuWCVInternetSettings -name 'ProxyPass' -value ""
    # 172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*
    # login.live.com;account.live.com;clientconfig.passport.net;wustat.windows.com;*.windowsupdate.com;*.wns.windows.com;*.hotmail.com;*.outlook.com;*.microsoft.com;*.msftncsi.com
    Set-ItemProperty -Path $hkcuWCVInternetSettings -name 'ProxyOverride' -value "localhost;<local>;127.*;10.*;172.*;192.168.*;*.lan;*.cn"
}

if ($SetWinHttpCurrentSession) {
    # https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest.getsystemwebproxy?view=net-6.0
    # [System.Net.WebRequest]::GetSystemWebProxy()

    $proxy = NewProxy

    # https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest.defaultwebproxy?view=net-6.0
    [System.Net.WebRequest]::DefaultWebProxy
    [System.Net.WebRequest]::DefaultWebProxy = $proxy
}

if ($SetWinHttpGlobally) {
    & netsh winhttp show proxy

    # import proxy config from Internet Explorer
    # & netsh winhttp import proxy source=ie

    if ('' -eq [string]$Url) {
        & netsh winhttp reset proxy
    }
    else {
        & netsh winhttp set proxy $Url bypass-list= "*.local,10.*,172.*,192.168.*,*.lan,*.cn"
    }
}

if ($SetNetCoreCurrentSession) {
    $proxy = NewProxy

    # https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.defaultproxy?view=netcore-3.1
    [System.Net.Http.HttpClient]::DefaultProxy
    [System.Net.Http.HttpClient]::DefaultProxy = $proxy
}
