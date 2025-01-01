
### [COPY][ref-dockerfile-copy] vs [ADD][ref-dockerfile-add]

[ref-dockerfile-copy]: https://docs.docker.com/reference/dockerfile/#copy
[ref-dockerfile-add]: https://docs.docker.com/reference/dockerfile/#add

https://docs.docker.com/build/building/best-practices/#add-or-copy

`docker build` 会确定一个 build context，一般是当前目录，把它**全量**发给 docker daemon处理。所以 COPY/ADD 只能从 build context 之内复制文件，所以无法使用绝对路径。

不然就会遇到 `COPY failed: stat /var/lib/docker/tmp/docker-builderXXXXXX/...: no such file or directory` 的错误。

`WORKDIR` 指定的是容器内的当前路径，如 `COPY a.txt .` 会复制到该路径。

COPY 用法如：

```Dockerfile
COPY <src> <dst>
COPY ["<src>", "<dst>"]

# 可以使用 Golang-style 通配符
COPY a* .

# 特殊：后加的 multi-stage 用法补丁
COPY --from=0 <src> <dst>
```

ADD 用法如：

```Dockerfile
ADD <src> <dst>

# 自动解压缩，也许这是 ADD 的最佳场景？
ADD a.tar.gz .

# 源文件来自网络，官方的最佳实践不推荐这么用，因为 ADD 会创建一层，可以使用 curl 等替代
ADD http://example.com/big.tar.xz /usr/src/things
RUN tar -xJF /usr/src/things/big.tar.gz -C /usr/src/things \
    && make -C /usr/src/things all
# 建议写法如下
RUN mkdir -p /usr/src/things \
    && curl -SL http://example.com/big.tar.xz | tar -xJC /usr/src/things \
    && make -C /usr/src/things all
```

### [multi-stage][ref-dockerfile-multi-stage]

[ref-dockerfile-multi-stage]: https://docs.docker.com/build/building/multi-stage/

如果一个 Dockerfile 文件包含多个 `FROM`，那么就启用多阶段了，实质上是为当前构建产物定义了一个私有的 tag，这也使得多阶段本质上成了语法糖。

语法如 `FROM <tag> [AS <private-tag>]`，省略的话自动以 0 1 2.. 命名。

多阶段一般用于 COPY 指令，`COPY --from=0` `COPY --from=<external-built-image-tag>`。

有时也用于构建产物矩阵：

```Dockerfile
FROM alpine:latest AS builder
RUN apk --no-cache add build-base

FROM builder AS build1
COPY source1.cpp source.cpp
RUN g++ -o /binary source.cpp

FROM builder AS build2
COPY source2.cpp source.cpp
RUN g++ -o /binary source.cpp
```
