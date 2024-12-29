<#
.LINK
https://learn.microsoft.com/zh-cn/azure/application-gateway/self-signed-certificates
#>
$openssl = Join-Path (& scoop prefix git) "usr\bin\openssl.exe"

if ($CreateCA) {
    # 生成私钥
    & $openssl ecparam -genkey -name prime256v1 -out ca.key
    # 生成证书签名请求
    & $openssl req -new -key ca.key -out ca.csr -sha256 -subj "/CN=ca.local"
    # 生成自签名证书
    & $openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -sha256 -days 3650

    Remove-Item ca.csr
}

if ($CreateServer) {
    # 生成私钥
    & $openssl ecparam -genkey -name prime256v1 -out server.key
    # 生成证书签名请求
    & $openssl req -new -key server.key -out server.csr -sha256 -subj "/CN=server.local"
    # 签名证书
    & $openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -sha256 -days 3650
    # 验证证书
    # & $openssl verify -CAfile ca.crt server.crt
    & $openssl x509 -in server.crt -text -noout

    Remove-Item server.csr
}
