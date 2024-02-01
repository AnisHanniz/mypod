<?php session_start();
include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
<!DOCTYPE html>

<html lang="fr">

<head>
  <title> Plateforme Médecins - MyPod</title>
  <meta charset="utf-8" />
  <link rel="stylesheet" href="style.css" />
  <!-- <script src="http://code.jquery.com/jquery-3.6.0.min.js"></script> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>

<body>
    <ul>
      <?php if (isset($_SESSION['pseudo'])) {
	echo "josh";
        $pseudo = $_SESSION['pseudo'] ?>

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


      <?php } else { 
	?>
        <li>
          <form action="bdd.php" method="POST">
          <h1 style="color: #000;">Bienvenue sur MyPod</h1>

            <br><br>
            <label>Adresse E-mail :</label>
            <input type="email" name="email">
            <label>Mot de Passe :</label>
            <input type="password" name="password">
            <button type="submit">Connexion</button><br><br>
            <span>Pas encore inscrit ? <a href="pagedinscription.php">Faites une demande !</a></span>
          </form>
        </li>
      

      <?php  } ?>
    </ul>

</body>

</html>
