#!/usr/bin/env bash

sudo yum update -q -y
sudo yum install -q -y vim htop lsof

mkdir /app
cd /app

export SHADOWSOCKS_VER=v3.2.0
export LIBSODIUM_VER=1.0.16
export MBEDTLS_VER=2.13.0

sudo yum install -y -q git gettext gcc autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel pcre-devel

# Installation of Libsodium
wget -q https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VER.tar.gz
tar xf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
sudo make install
popd
sudo ldconfig

# Installation of MbedTLS
wget -q https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS=-fPIC
sudo make DESTDIR=/usr install
popd
sudo ldconfig

# Installation of ss-libev
mkdir ss-libev
pushd ss-libev
git init .
git remote add origin https://github.com/shadowsocks/shadowsocks-libev.git
git pull origin +refs/tags/$SHADOWSOCKS_VER:master --depth=1
git submodule update --init --recursive
./autogen.sh && ./configure && make
sudo make install
popd

# enable TCP BBR
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && sudo ./bbr.sh

# write run script
RUN_SS_SCRIPT_PATH="./run-ss.sh"
SS_PORT="1050"
SS_METHOD="aes-256-cfb"
SS_PASSWD="HelloWorld."
SS_TIMEOUT="15"

touch ${RUN_SS_SCRIPT_PATH}
echo "#!/usr/bin/env bash" >> ${RUN_SS_SCRIPT_PATH}
echo "/usr/local/bin/ss-server -s \"0.0.0.0\" -s \"::\" -6 -p ${SS_PORT} -u -m \"${SS_METHOD}\" -k \"${SS_PASSWD}\" -t ${SS_TIMEOUT}" >> ${RUN_SS_SCRIPT_PATH}
chmod +x ${RUN_SS_SCRIPT_PATH}

BG_RUN_SS_SCRIPT_PATH="./bg-run-ss.sh"
touch ${BG_RUN_SS_SCRIPT_PATH}
echo "#!/usr/bin/env bash" >> ${BG_RUN_SS_SCRIPT_PATH}
echo "SCRIPT_DIR=$(cd \"$(dirname \"$0\")\"; pwd)" >> ${BG_RUN_SS_SCRIPT_PATH}
echo "nohup ${SCRIPT_DIR}/${RUN_SS_SCRIPT_PATH} >/dev/null 2>&1 &" >> ${BG_RUN_SS_SCRIPT_PATH}
chmod +x ${BG_RUN_SS_SCRIPT_PATH}

# run ss-server on background
${BG_RUN_SS_SCRIPT_PATH}
