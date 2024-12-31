ping -q -c1 -t1 $1 | tr -d '()' | awk '/^PING/{print $3}'
