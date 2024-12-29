
function FindProxyForURL(url, host) {
    return "SOCKS5 127.0.0.1:4000; SOCKS 127.0.0.1:4000; PROXY 127.0.0.1:4001; ";
}
