<?php
//第一种方式 利用扩展
$Redis = new Redis();
$Redis->connect('127.0.0.1', 6379);
//当执行scan命令后，返回的结果集为空的话，函数不返回，而是直接继续执行scan命令
$Redis->setOption(Redis::OPT_SCAN,Redis::SCAN_RETRY);

$p = 'KEYS|20180415|*|'; 
$iterator = null;
while ($keys = $Redis->scan($iterator, $p)) {
    foreach ($keys as $key) {
        echo $key . PHP_EOL;
    }
    usleep(100);
}
exit;