<?php
if( ($_SERVER['PHP_AUTH_USER'] =='admin' && ( md5('^_^'.$_SERVER['PHP_AUTH_PW']) == 'f3a78e1c032a732e91ede2346209c30f') ) ){//123
	exit('Login Success …………');
}else{
	authenticate();
}

function authenticate() {
  header('WWW-Authenticate: Basic realm="Http Authentication System"');
  header('HTTP/1.0 401 Unauthorized');
  exit;
}