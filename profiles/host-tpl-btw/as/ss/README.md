
copy default.json, run-default, ss@.service

```bash
pushd $HOME
$SS_VER=v1.20.0
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/${SS_VER}/shadowsocks-${SS_VER}.x86_64-unknown-linux-gnu.tar.xz

mkdir -p /as/bin
pushd /as/bin
tar xf $HOME/shadowsocks-${SS_VER}.x86_64-unknown-linux-gnu.tar.xz
popd
```

```bash
pushd /as/ss
chmod +x run-default
ln -s $PWD/ss@.service /lib/systemd/system/ss@.service
popd

systemctl daemon-reload
systemctl enable ss@default.service
systemctl restart ss@default.service
# or: service ss@default restart
```
