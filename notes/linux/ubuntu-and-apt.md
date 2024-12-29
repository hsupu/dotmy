
## no ads on shell

```bash
rm /etc/update-motd.d/50-motd-news
touch ~/.hushlogin
```

## apt proxy and in-secure https

`vim /etc/apt/apt.conf.d/12proxy`

```ini
Acquire::http::proxy "socks5h://127.0.0.1:4000";
Acquire::https::proxy "socks5h://127.0.0.1:4000";

Acquire::AllowInsecureRepositories "true";
Acquire::AllowDowngradeToInsecureRepositories "true";

; 按需代理
Acquire::http::proxy ""
Acquire::http::proxy::download.opensuse.org "socks5h://host:4000";
```
