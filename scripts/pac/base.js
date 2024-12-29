
// var proxyTarget = "SOCKS5 127.0.0.1:4000; SOCKS 127.0.0.1:4000; PROXY 127.0.0.1:4001";
var proxyTarget = "PROXY 127.0.0.1:4001";

// var test_geoip = function(url, host, schema) {
//     var ipv4;
//     var regexIsIpv4 = /^(\d+.){3}\d+$/;
//     if (regexIsIpv4.test(host)) {
//         ipv4 = host;
//     }
//     else {
//         ipv4 = dnsResolve(host);
//     }
//     if (hostIP == 0) {
//         return proxyTarget;
//     }
//     return "DIRECT";
// };

var FindProxyForURL = function(url, host) {
    "use strict";

    if (isPlainHostName(host)) return "DIRECT";

    host = host.toLowerCase();
    if (/^127\.\d+\.\d+\.\d+$/.test(host) || /^::1$/.test(host) || /^localhost$/.test(host)) return "DIRECT";

    if (dnsDomainIs(host, ".local")) return "DIRECT";
    if (dnsDomainIs(host, ".lan")) return "DIRECT";

    // gov
    if (dnsDomainIs(host, ".cn")) return "DIRECT";
    if (dnsDomainIs(host, ".hk")) return proxyTarget;
    if (dnsDomainIs(host, ".tw")) return proxyTarget;
    if (dnsDomainIs(host, ".jp")) return proxyTarget;
    if (dnsDomainIs(host, ".kr")) return proxyTarget;
    if (dnsDomainIs(host, ".sg")) return proxyTarget;

    // microsoft
    if (dnsDomainIs(host, "cn.bing.com")) return "DIRECT";
    if (dnsDomainIs(host, ".bing.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".live.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".microsoft.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".msn.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".office.com")) return proxyTarget;
    if (dnsDomainIs(host, ".onedrive.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".outlook.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".skype.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".windows.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".windowsupdate.com")) return proxyTarget;

    // apple
    if (dnsDomainIs(host, ".apple.com")) return proxyTarget;
    if (dnsDomainIs(host, ".icloud.com")) return proxyTarget;
    if (dnsDomainIs(host, ".itunes.com")) return proxyTarget;

    // amazon
    if (dnsDomainIs(host, ".blogblog.com")) return proxyTarget;

    // github
    if (dnsDomainIs(host, ".github.com")) return proxyTarget;
    if (dnsDomainIs(host, ".githubusercontent.com")) return proxyTarget;

    // google
    if (dnsDomainIs(host, ".blogger.com")) return proxyTarget;
    if (dnsDomainIs(host, ".google.com")) return proxyTarget;
    if (dnsDomainIs(host, ".google.com.hk")) return proxyTarget;
    if (dnsDomainIs(host, ".google.co")) return proxyTarget;
    if (dnsDomainIs(host, ".google.jp")) return proxyTarget;
    if (dnsDomainIs(host, ".google.kr")) return proxyTarget;
    if (dnsDomainIs(host, ".googleapis.com")) return proxyTarget;
    if (dnsDomainIs(host, ".googleusercontent.com")) return proxyTarget;
    if (dnsDomainIs(host, ".googlevideo.com")) return proxyTarget;
    if (dnsDomainIs(host, ".gstatic.com")) return proxyTarget;
    if (dnsDomainIs(host, ".youtube.com")) return proxyTarget;
    if (dnsDomainIs(host, ".ytimg.com")) return proxyTarget;

    // twitter
    if (dnsDomainIs(host, ".twitter.com")) return proxyTarget;
    if (dnsDomainIs(host, ".twimg.com")) return proxyTarget;

    // fb
    if (dnsDomainIs(host, ".facebook.com")) return proxyTarget;
    if (dnsDomainIs(host, ".fbcdn.net")) return proxyTarget;
    if (dnsDomainIs(host, ".fb.me")) return proxyTarget;
    if (dnsDomainIs(host, ".fb.com")) return proxyTarget;
    if (dnsDomainIs(host, ".fbcdn.com")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbstatic-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbstatic.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbstatic-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-dragon-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-profile-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-sphotos-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-video-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-vthumb-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-creative-a.akamaihd.net")) return proxyTarget;
    // if (dnsDomainIs(host, ".fbcdn-photos-a.akamaihd.net")) return proxyTarget;

    return "DIRECT";
};
