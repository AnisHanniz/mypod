<?php
session_start();
include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <title>Inscription - MyPod</title>
    <link rel="stylesheet" href="style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<body>
    <div class="container">
        <div class="login-form">
            <h1>Bienvenu sur MyPod</h1>
            <h2 style="text-align : center">Inscription</h2></br>
            <h3 style="text-align : center">Votre demande sera traitée dès que possible</h3></br>
            <p style="text-align : center">Pour revenir en arrière, cliquez <a href="index.php">ici</a>.</p></br>
            <form method="POST" action="donneedinscription.php">
                <div class="form-group">
                    <label>Nom</label>
                    <input type="text" name="nom" required>
                </div>
                <div class="form-group">
                    <label>Prénom</label>
                    <input type="text" name="prenom" required>
                </div>
                <div class="form-group">
                    <label>Adresse E-mail</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Mot de Passe</label>
                    <input type="password" name="password" minlength="8" required>
                </div>
                <div class="form-group">
                    <label>Numéro de téléphone</label>
                    <input type="tel" name="telephone" pattern="[0-9]{10}" required>
                    <small>10 chiffres sans espaces ni caractères spéciaux.</small>
                </div>
                <button type="submit" id="creer">Créer mon profil !</button>
            </form>
        </div>
    </div>
</body>

</html>


