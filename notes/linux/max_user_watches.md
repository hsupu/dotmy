
```bash
if ! grep -qF "max_user_watches" /etc/sysctl.conf ; then
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
fi

sudo sysctl -p >/dev/null 2>&1
sudo sysctl --system >/dev/null 2>&1
```
