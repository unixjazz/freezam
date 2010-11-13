<?php

	//$output = shell_exec("cat /var/www/omg.R | /usr/bin/R --vanilla", $output);
	//unset($output);
	//exec("/usr/bin/R --vanilla --file='/var/www/omg.R' ", $output);
	//echo "hello";
	//print_r($output);
	
	$output = readfile("/var/www/result.txt")
?>
