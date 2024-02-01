
<?php
session_start();
$id = $_SESSION['idutilisateur'];
$of = $_POST["of"];
$connect = mysqli_connect("localhost", "saif", "fumelois8", "projet");
echo mysqli_connect_error();
$requete = "SELECT * FROM events WHERE of='$of' && id_user = '$id'";
$res = mysqli_query($connect, $requete);
while ($ligne = mysqli_fetch_array($res)) {
    echo "<p class='aEvent' data-id='{$ligne['id']}'>•
    <input type='hidden' class='id' value='{$ligne['id']}' />
        <span class='title'>{$ligne['title']}</span>
        <span class='of'>{$ligne['of']}</span>
        <span class='description'>{$ligne['description']}</span> de <span class='at'>{$ligne['at']}</span> à <span class='at2'>{$ligne['at2']}</span>
     <input type='hidden' class='place' value='{$ligne['place']}' /></br>
     <button class='updateBtn' type='button' type='button' name='modify'>Modifier</button> 
     <button class='deleteBtn' type='button'>Supprimer</button></p>";
}
echo mysqli_error($connect);
mysqli_close($connect);
?>

