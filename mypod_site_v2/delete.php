<?php 
$id = $_POST["id"];

$connect = mysqli_connect("localhost", "saif", "fumelois8", "projet");
echo mysqli_connect_error();
$requete = "DELETE FROM events WHERE id = '$id' ";
$res = mysqli_query($connect, $requete);
echo mysqli_error($connect);
mysqli_close($connect);

?>