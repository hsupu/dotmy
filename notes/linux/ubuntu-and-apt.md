
## no ads on shell

```bash
rm /etc/update-motd.d/50-motd-news
touch ~/.hushlogin
```

## apt proxy and in-secure https

```bash
vim /etc/apt/apt.conf.d/12proxy
        Acquire::http::proxy "socks5h://127.0.0.1:5000";
        Acquire::https::proxy "socks5h://127.0.0.1:5000";Acquire::AllowInsecureRepositories "true";
        Acquire::AllowDowngradeToInsecureRepositories "true";
```
