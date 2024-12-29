
https://docs.docker.com/config/daemon/

```js
{
  "authorization-plugins": [],
  // 默认空：使用 NAT；设为 none 则禁用 NAT
  "bridge": "",
  // 27.0.3 不支持？
  "cluster-advertise": "",
  // 27.0.3 不支持？
  "cluster-store": "",
  // 默认 C:\ProgramData\Docker
  "data-root": "",
  "debug": true,
  // 27.0.3 不支持？
  "default-ulimits": {},
  // 27.0.3 不支持？
  "disable-legacy-registry": false,
  "dns": [],
  "dns-opts": [],
  "dns-search": [],
  "exec-opts": [],
  "features": {
    "buildkit": true
  },
  "fixed-cidr": "",
  "group": "docker-users",
  "hosts": [
    // tcp://127.0.0.1:2375 for plain
    // tcp://0.0.0.0:2376 for tls
    "npipe://"
  ],
  "insecure-registries": [],
  "labels": [],
  "log-driver": "",
  "log-level": "",
  "mtu": 0,
  "pidfile": "",
  "raw-logs": false,
  "registry-mirrors": [
  ],
  // 27.0.3 不支持？
  "storage-driver": "",
  "storage-opts": [],
  "tlscacert": "",
  "tlscert": "",
  "tlskey": "",
  "tlsverify": true
}
```
