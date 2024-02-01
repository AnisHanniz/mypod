
<?php
session_start();
$id = $_SESSION['idutilisateur'];
$connect = mysqli_connect("localhost", "saif", "fumelois8", "projet");
echo mysqli_connect_error();
$requete = "SELECT * FROM preference WHERE id_user = '$id'";
$tab =  [31];
$i = 0;
$res = mysqli_query($connect, $requete);
while ($ligne = mysqli_fetch_array($res)) {
    $tab[$i] = $ligne['samedi'];
    ++$i;
    $tab[$i] = $ligne['dimanche'];
    ++$i;
    $tab[$i] = $ligne['ferie'];
    ++$i;
    $tab[$i] = $ligne['event'];
    ++$i;
    $tab[$i] = $ligne['limit_event'];
}
echo json_encode($tab);
echo mysqli_error($connect);
mysqli_close($connect);
?>

