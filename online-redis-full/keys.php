<?php
//KEYS pattern KEYS|1|*|Ymd
$Redis = new Redis();
$Redis->connect('127.0.0.1', 6379);

$start = strtotime("2018/03/05");
$end = strtotime("2018/04/08");

for(;$start<=$end;) {
	$ymd = date('Ymd',$start);
	$p = 'KEYS|1|*|'.$ymd;
	$aKeys = $Redis->keys($p);
	echo $p,'|',count($aKeys),PHP_EOL;

	foreach ($aKeys as $key) {
		$Redis->del($key);
	}
	$start += 86400;
	usleep(100);
}
exit;