<?php
try {
    $connexion = mysqli_connect("localhost", "new_user", "password", "myPodDB");

    // Vérifier la connexion
    if (!$connexion) {
        die("La connexion a échoué : " . mysqli_connect_error());
    }

    // Récupérer les données du formulaire
    $nom = $_POST["nom"];
    $prenom = $_POST["prenom"];
    $specialite = $_POST["specialite"];
    $numeroTel = $_POST["telephone"];
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Vérifier si l'email est déjà utilisé
    $requete = "SELECT * FROM Medecins WHERE Email = '$email'";
    $res = mysqli_query($connexion, $requete);
    $resultat = mysqli_fetch_array($res);

    if ($resultat) {
        echo "L'email est déjà utilisé.";
        header('Location: pagedinscription.php');
    } else {
        // Insérer le nouveau profil dans la table Medecins
        $requete = "INSERT INTO Medecins (nom, prenom, Specialite, NumeroTel, Email, motdepasse) 
                    VALUES ('$nom', '$prenom', '$specialite', '$numeroTel', '$email', '$password')";
        mysqli_query($connexion, $requete);

        // Rediriger vers la page d'accueil
        header('Location: index.php');
    }

    // Fermer la connexion
    mysqli_close($connexion);
} catch (Exception $e) {
    die('Erreur : ' . $e->getMessage());
}
?>
