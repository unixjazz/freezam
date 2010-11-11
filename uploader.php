<H1>Uploaded!</H1>
<?php
echo 'Singer: '.$_POST['fsinger'].'<br>';
echo 'Title: '.$_POST['ftitle'];

$target_path = "uploads/";
$target_path = $target_path . basename( $_FILES['uploadedfile']['name']); 

if($a = move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
    echo "<br>"."The file ".  basename( $_FILES['uploadedfile']['name']). 
    " has been uploaded";
} else{
    echo "<br>"."There was an error uploading the file, please try again!";
}

echo "<br>".$a;

?>
