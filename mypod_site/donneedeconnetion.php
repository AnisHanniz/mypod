<?php
session_start();

// On vérifie qu'on a reçu l'email et le mot de passe du formulaire
if (isset($_POST['email']) && isset($_POST['password'])) {
    // Connexion à la base de données
    $db = mysqli_connect("localhost", "new_user", "password", "myPodDB");

    // On applique les fonctions mysqli_real_escape_string et htmlspecialchars
    // pour éliminer toute attaque de type injection SQL et XSS
    $email = mysqli_real_escape_string($db, htmlspecialchars($_POST['email']));
    $password = mysqli_real_escape_string($db, htmlspecialchars($_POST['password']));

    if ($email !== "" && $password !== "") {
        $requete = "SELECT count(*) FROM registre WHERE 
            adressemail = '" . $email . "' AND motdepasse = '" . $password . "'";
        $exec_requete = mysqli_query($db, $requete);
        $reponse = mysqli_fetch_array($exec_requete);
        $count = $reponse['count(*)'];

        if ($count != 0) { // Email et mot de passe corrects
            // Remonte l'id de l'utilisateur depuis la base de données
            $idRequete = "SELECT id FROM registre WHERE
                adressemail = '" . $email . "' AND motdepasse = '" . $password . "'";
            $exec_id = mysqli_query($db, $idRequete);
            $reponse_id = mysqli_fetch_array($exec_id);
            $_SESSION['idutilisateur'] = $reponse_id["id"];
            header('Location: bdd.php'); // Redirige vers la page bdd.php après la connexion
        } else {
            header('Location: index.php?erreur=1'); // Email ou mot de passe incorrect
        }
    } else {
        header('Location: index.php?erreur=2'); // Email ou mot de passe vide
    }
} else {
    // Sinon, on redirige vers l'accueil
    header('Location: index.php');
}

mysqli_close($db); // Fermer la connexion
?>

