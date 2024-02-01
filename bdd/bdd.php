<?php
header("Content-Type: application/json");

$servername = "localhost";
$username = "votre_utilisateur_mysql";
$password = "votre_mot_de_passe_mysql";
$database = "myPodDB";

// Connexion à MySQL
$conn = new mysqli($servername, $username, $password);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Erreur de connexion à la base de données: " . $conn->connect_error);
}

// Création de la base de données si elle n'existe pas déjà
$sqlCreateDatabase = "CREATE DATABASE IF NOT EXISTS $database";
if ($conn->query($sqlCreateDatabase) === FALSE) {
    die("Erreur lors de la création de la base de données: " . $conn->error);
}

// Sélectionner la base de données
$conn->select_db($database);

// Création de la table "Patients" si elle n'existe pas déjà
$sqlCreateTable = "CREATE TABLE IF NOT EXISTS Patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    NomPren VARCHAR(255) NOT NULL,
    DateDeNais DATE,
    Adresse VARCHAR(255),
    NumeroTel VARCHAR(15),
    Email VARCHAR(255)
)";
if ($conn->query($sqlCreateTable) === FALSE) {
    die("Erreur lors de la création de la table 'Patients': " . $conn->error);
}

// Exemple de route pour récupérer tous les patients
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['patients'])) {
    $sql = "SELECT * FROM Patients";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $patients = array();
        while ($row = $result->fetch_assoc()) {
            $patients[] = $row;
        }
        echo json_encode($patients);
    } else {
        echo json_encode(array());
    }
}

// Exemple de route pour créer un nouveau patient
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['new_patient'])) {
    $NomPren = $_POST['NomPren'];
    $DateDeNais = $_POST['DateDeNais'];
    $Adresse = $_POST['Adresse'];
    $NumeroTel = $_POST['NumeroTel'];
    $Email = $_POST['Email'];

    $sql = "INSERT INTO Patients (NomPren, DateDeNais, Adresse, NumeroTel, Email) VALUES ('$NomPren', '$DateDeNais', '$Adresse', '$NumeroTel', '$Email')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(array("message" => "Patient créé avec succès"));
    } else {
        echo json_encode(array("error" => "Erreur lors de la création du patient: " . $conn->error));
    }
}

// Vous pouvez créer des routes similaires pour d'autres tables et opérations CRUD (Update, Delete).

// Fermer la connexion à la base de données
$conn->close();
?>

