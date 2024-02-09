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
        // Vérification si c'est un médecin
        $requeteMedecin = "SELECT nom, MedecinID FROM Medecins WHERE 
            Email = '" . $email . "' AND motdepasse = '" . $password . "'";
        $exec_requeteMedecin = mysqli_query($db, $requeteMedecin);
        $reponseMedecin = mysqli_fetch_array($exec_requeteMedecin);
        $countMedecin = mysqli_num_rows($exec_requeteMedecin);

        // Vérification si c'est un administrateur
        $requeteAdmin = "SELECT AdminID FROM Admins WHERE 
            Email = '" . $email . "' AND PasswordHash = '" . $password . "'";
        $exec_requeteAdmin = mysqli_query($db, $requeteAdmin);
        $countAdmin = mysqli_num_rows($exec_requeteAdmin);

        // Débogage : Afficher les informations pour comprendre ce qui se passe
        echo "Count Medecin: " . $countMedecin . "<br>";
        echo "Count Admin: " . $countAdmin . "<br>";

        if ($countMedecin > 0 || $countAdmin > 0) {
            if ($countMedecin > 0) { // C'est un médecin
                $_SESSION['adressemail'] = $email;
                $_SESSION['password'] = $password;
                $_SESSION['nom'] = $reponseMedecin['nom'];
                $_SESSION['id'] = $reponseMedecin['MedecinID'];
            } elseif ($countAdmin > 0) { // C'est un administrateur
                $_SESSION['adressemail'] = $email;
            }
            header('Location: bdd.php'); // Redirige vers la page admin.php après la connexion
            exit(); // Terminer le script après la redirection
        } else {
            echo "<script>alert('Password is incorrect!')</script>";
            header('Location: index.php?erreur=1'); // Email ou mot de passe incorrect
            exit(); // Terminer le script après la redirection
        }
    } else {
        header('Location: index.php?erreur=2'); // Email ou mot de passe vide
        exit(); // Terminer le script après la redirection
    }
} else {
    // Sinon, on redirige vers l'accueil
    header('Location: index.php');
    exit(); // Terminer le script après la redirection
}

mysqli_close($db); // Fermer la connexion
?>
