<?php 
session_start();
 if(isset($_SESSION['pseudo'])) {
    $id_user = $_SESSION['idutilisateur'];
    $connect = mysqli_connect("localhost", "saif", "fumelois8", "projet");
        $ferie = $_POST["pref_ferie"];
        $samedi = $_POST["pref_samedi"];
        $dimanche = $_POST["pref_dimanche"];
        $affichage = $_POST["affichage"];
        $limit = $_POST["limit"];
        $requete = "UPDATE preference SET samedi = '$samedi',dimanche = '$dimanche',ferie = '$ferie',limit_event = '$limit',event = '$affichage' WHERE id_user = $id_user";
        mysqli_query($connect, $requete);
        echo mysqli_error($connect);
        mysqli_close($connect);
        header('Location: index.php');
}
