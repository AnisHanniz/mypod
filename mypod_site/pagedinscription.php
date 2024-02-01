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
    <title>Inscription</title>
    <link rel="stylesheet" href="style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<body>
    <ul>
        <?php
        if (isset($_SESSION['pseudo'])) {
            $pseudo = $_SESSION['pseudo'];
        ?>
            <li class="user"><a><?php echo $pseudo; ?></a>
                <ul class="submenu">
                    <li><a href="preference.html">Préférences</a>
                        <ul>
                            <li> </li>
                        </ul>
                    </li>
                    <li><a href="deconnection.php">Déconnexion</a></li>
                </ul>
            </li>
        <?php
        } else {
        ?>
            <li>
                <div class="registre">
                    <div>
            <h1>Bienvenu sur MyPod</h1>
            <br><br>
                        <h3>Inscription</h3>
                        <h4>Votre demande sera traitée dès que possible</h4><br><br><p><a href="index.php">Ici</a> pour revenir en arrière.</p>
                        <form method="POST" action="donneedinscription.php">
                            <div>
                                <label>Nom</label>
                                <input type="text" name="nom" required>
                            </div>
                            <div>
                                <label>Prénom</label>
                                <input type="text" name="prenom" required>
                            </div>
                            <div>
                                <label>Adresse E-mail</label>
                                <input type="email" name="email" required>
                            </div>
                            <div>
                                <label>Mot de Passe</label>
                                <input type="password" name="password" required>
                            </div>
                            <button type="submit" id="creer">Envoyer</button>
                        </form>
                    </div>
                </div>
            </li>
        <?php
        }
        ?>
    </ul>
</body>

</html>

