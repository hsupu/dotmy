
```bash
apt install vim tmux htop
```

SSH 安全

```bash
vim .ssh/authorized_keys
# add ssh key
exit # to check if ssh key works

vim /etc/ssh/sshd_config
systemctl daemon-reload
service ssh restart
exit # to check if sshd config works
```

计划任务

```bash
apt install crontab
crontab -e
# check file /var/spool/cron/crontabs/$(whoami)
```
