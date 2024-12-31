
# "xpwsl\0\0\0"
# PREFIX=fec0:7870:7773:6c00 # site-local
PREFIX=fd00:7870:7773:6c00 # unique-local
PF6LEN=56
SUBNET=${PREFIX}::/$PF6LEN
HSTIP6=${PREFIX}::1
WSLIP6=${PREFIX}::2

sudo ip addr add $WSLIP6/64 dev eth0
sudo ip -6 route add default via $HSTIP6

TESTHOST=mirrors6.tuna.tsinghua.edu.cn
TESTIP=$(ping6 -q -c1 -t1 $TSETHOST | tr -d '()' | awk '/^PING/{print $3}')
# ip -6 route show to match $TESTIP
ip -6 route get $TESTIP
ping6 $TESTHOST
ping6 2400:3200::1 # ali dns server
