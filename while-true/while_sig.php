<?php
set_time_limit(0);
ini_set('memory_limit', '512M');

pcntl_async_signals(true);
function sighandler($signal){
	echo "REV SIG:".$signal,PHP_EOL;
	exit;
}

pcntl_signal(SIGUSR1, 'sighandler');
pcntl_signal(SIGUSR2, 'sighandler');
$oldset = [];

$i=0;
while(1){
	pcntl_sigprocmask(SIG_BLOCK, array(SIGUSR1, SIGUSR2), $oldset);
	$i++;
	$start = 1;
	$end = $i*10;
	echo "=======================================================================",PHP_EOL;
	for($start;$start<=$end;$start++){
		echo $start,PHP_EOL;
		sleep(1);
	}
	pcntl_sigprocmask(SIG_UNBLOCK, array(SIGUSR1, SIGUSR2), $oldset); //代码块执行完
}
exit;
