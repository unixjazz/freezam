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

<h2><a href="#">Build Database</h2>
<div class="articles">
<form enctype="multipart/form-data" action="uploader.php" method="POST">
Singer:<br /> <input type="text" name="fsinger" size=55/><br>
Title:<br /> <input type="text" name="ftitle" size=55/><br>
<input type="hidden" name="MAX_FILE_SIZE" value="1000000000" />
Choose a file to upload:<br />
<input name="uploadedfile" type="file" size=46/><br />
<br /><input type="submit" value="Upload File" />
</form>
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
