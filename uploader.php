<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>::freeShazam::</title>
<meta http-equiv="Content-Language" content="English" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="style.css" media="screen" />
</head>
<body>
<div id="wrap">
<div id="header">
<img src="images/logo.jpg">
</div>
<div id="menu">
<ul>
<li><a href="index.php">Home</a></li>
<li><a href="buildDB.php">Populate Database</a></li>
<li><a href="match.php">Identify Song</a></li>
</ul>
</div>

<div id="content">
<div class="right"> 

<h2><a href="#">Upload was finished with success!</a></h2>
<div class="articles">
<?php

$target_path = "uploads/";
#$target_path = $target_path . basename( $_FILES['uploadedfile']['name']);
$target_path = $target_path . basename('sample1.wav');

if($a = move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
    echo "<br>"."The file <b>".  basename( $_FILES['uploadedfile']['name']).
    "</b> was successfully archived in your DB.</br>";
    unset($output);
    exec("cat /var/www/omg.R | /usr/bin/R --vanilla", $output);
?>
<a href="processR.php">Next(Please wait 10secs before you click Next)</a>
<?php
} else{
    echo "<br>"."There was an error uploading the file, please try again!";
}

echo "<br>".$a;

?>
</div>
</div>

<div class="left"> 

<h2>Sections:</h2>
<ul>
<li><a href="index.php">Home</a></li>
<li><a href="buildDB.php">Populate Database</a></li>
<li><a href="match.php">Identify Song</a></li>
<li><a href="credits.php">Authors</a></li>
</ul>

</div>
<div style="clear: both;"> </div>
</div>

<div id="footer">
2010 Copyleft - All Rights Reversed</a>
</div>
</div>

</body>
</html>
