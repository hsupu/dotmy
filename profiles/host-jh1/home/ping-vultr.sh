<?php
$hosts = [
    ['Seoul, KR', 'sel-kor-ping.vultr.com'],
    ['Tokyo, JP', 'hnd-jp-ping.vultr.com'],
    ['Singapore, SG', 'sgp-ping.vultr.com'],
    //['Sydney, AU', 'syd-au-ping.vultr.com'],
    ['Frankfurt, DE', 'fra-de-ping.vultr.com'],
    ['Amsterdam, NL', 'ams-nl-ping.vultr.com'],
    ['London, UK', 'lon-gb-ping.vultr.com'],
    ['Paris, FR', 'par-fr-ping.vultr.com'],
    ['Seattle, US-E', 'wa-us-ping.vultr.com'],
    ['Silicon Valley, US-W', 'sjo-ca-us-ping.vultr.com'],
    ['Los Angeles, US-W', 'lax-ca-us-ping.vultr.com'],
    ['Chicago, US-E', 'il-us-ping.vultr.com'],
    ['Dallas, US-M', 'tx-us-ping.vultr.com'],
    ['New York / New Jersey, US-E', 'nj-us-ping.vultr.com'],
    ['Atlanta, US-E', 'ga-us-ping.vultr.com'],
    ['Miami, US-E', 'fl-us-ping.vultr.com'],
];

function url_100m($host) {
    return 'http://' . $host . '/vultr.com.100MB.bin';
}

function url_1000m($host) {
    return 'http://' . $host . '/vultr.com.1000MB.bin';
}

function name() {
    global $hosts;
    foreach ($hosts as $host) {
	echo $host[1] . "\t" . $host[0] . "\n";
    }
}

function ping() {
    global $hosts;
    $cmd = 'fping -c 10 -q -t 1000 ';
    foreach ($hosts as $host) {
        $cmd = $cmd . $host[1] . ' ';
    }
    $out = shell_exec($cmd);
    echo $out;
}

name();
ping();

