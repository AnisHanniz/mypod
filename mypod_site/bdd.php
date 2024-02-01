<?php
session_start();
include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Erreur de connexion à la base de données: " . $conn->connect_error);
}

$conn->select_db($database);

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css" />
    <title>Contenu de la Base de Données</title>
</head>
<body>
<nav>
    <ul>
        <?php if (isset($_SESSION['email'])) {
            $mail = $_SESSION['email'];
            ?>
            <li class="user">
                <a><?php echo $mail; ?></a>
                <ul class="submenu">
                    <li><a <?php if (file_exists('preference.html')) { echo 'href="preference.html"'; } ?>>Préférences</a>
                        <ul>
                            <li> </li>
                        </ul>
                    </li>
                    <li><a <?php if (file_exists('deconnection.php')) { echo 'href="deconnection.php"'; } ?>>Déconnexion</a></li>
                </ul>
            </li>
        <?php } ?>
    </ul>
</nav>
<h1 style="color: #000;">Contenu de la Base de Données</h1>

<?php

// Liste des tables à afficher
$tables = array("Patients", "Medecins", "Infos", "PlansTraitement", "BasalProfiles", "AppSettings", "HistoriqueInjections");

foreach ($tables as $table) {
    $sql = "SELECT * FROM $table";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo '<br><h2 style="text-align: center;">Table: ' . $table . '</h2>';
        echo '<table>';
        echo '<tr>';
        while ($fieldinfo = $result->fetch_field()) {
            echo '<th>' . $fieldinfo->name . '</th>';
        }
        echo '</tr>';
        while ($row = $result->fetch_assoc()) {
            echo '<tr>';
            foreach ($row as $key => $value) {
                echo '<td>' . $value . '</td>';
            }
            echo '</tr>';
        }
        echo '</table>';
    } else {
        echo '<p>Aucune donnée trouvée dans la table ' . $table . '.</p>';
    }
}

$conn->close();
?>
</body>
</html>

