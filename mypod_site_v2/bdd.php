<?php
session_start();
include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);
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
<style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
nav {
            position: fixed;
            top: 0;
            left: 0;
            width: 80px; /* Largeur de la barre de navigation */
            height: 100%;
            background-color: #333; /* Couleur de fond de la barre de navigation */
            padding-top: 20px; /* Espacement du haut */
        }
        nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        nav ul li {
            padding: 10px;
            text-align: center;
        }
        nav ul li a {
            text-decoration: none;
            color: #fff; /* Couleur du texte */
            display: block;
        }
        .content {
            margin-left: 200px; /* Espacement pour laisser de la place à la barre de navigation */
            padding: 20px;
        }
        h1 {
            color: #000;
        }
    </style>
</head>
<body>
<nav>
    <ul>
        <?php 
            $conn = new mysqli($servername, $username, $password, $database);

            if ($conn->connect_error) {
                die("Erreur de connexion à la base de données: " . $conn->connect_error);
            }

            $conn->select_db($database);

            $mail = $_SESSION['adressemail'];
            
            $sql = "SELECT * FROM Medecins WHERE  Email = '$mail'";
            $result_identity = $conn->query($sql);
            if($result_identity->num_rows >0){
               //la personne actuellement connectée est un medecin
               $nom = $_SESSION['nom'];
               $display = 1;
               $id = $_SESSION['id'];
                echo "<li>Bonjour Dr $nom</li>"; 
            } else {
                $display= 2;
                //la personne actuellement connectée est l'admin
                echo "<li>Vous êtes connecté en tant qu'administrateur</li>"; 
            }
        ?>
        <li><a href="deconnection.php"><img src="image1.png" width="50" height="50"></a></li>
        <li><a href="#"><img src="image0.png"></a></li>
        <li><a href="#"><img src="image0.png"></a></li>
    </ul>
</nav>
<h1 style="color: #000;">Contenu de la Base de Données</h1>

<?php

// Liste des tables à afficher

if($display == 1 ){
    $list_patient = "SELECT * FROM Patients WHERE MedecinID = '" . $id . "'";
    $resultat = $conn->query($list_patient);


    if ($resultat->num_rows > 0) {
        echo '<br><h2 style="text-align: center;">Liste des patients</h2>';
        echo '<table>';
        echo '<tr>';
        while ($fieldinfo = $resultat->fetch_field()) {
            echo '<th>' . $fieldinfo->name . '</th>';
        }
        echo '</tr>';
        while ($row = $resultat->fetch_assoc()) {
            echo '<tr>';
            foreach ($row as $key => $value) {
                echo '<td>' . $value . '</td>';
            }
            echo '</tr>';
        }
        echo '</table>';
    } else {
        echo '<p style="color: red;> Vous n avez aucun patient.</p>';
    }


} else {
    $tables = array("Patients", "Medecins", "Infos", "PlansTraitement", "BasalProfiles", "HistoriqueInjections");

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
                    echo '<td contenteditable="true">' . $value . '</td>';
                }
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<p style="color: red;">Aucune donnée trouvée dans la table ' . $table . '.</p>';
        }
    }
}
$conn->close();
?>
</body>
</html>

