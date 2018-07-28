<?php
set_time_limit(0);
ini_set('memory_limit', '512M');
$i=0;
while(1){
	$i++;
	$start = 1;
	$end = $i*10;
	echo "=======================================================================",PHP_EOL;
	for($start;$start<=$end;$start++){
		echo $start,PHP_EOL;
		sleep(1);
	}
}
exit;
