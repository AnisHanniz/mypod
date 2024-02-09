<?php
session_start();
include("config.php");
error_reporting(E_ALL);
ini_set('display_errors', 1);


require 'phpmailer/src/Exception.php';
require __DIR__.'/phpmailer/src/PHPMailer.php';
require 'phpmailer/src/SMTP.php';


use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;  

$mail = new PHPMailer(true);
$mail -> isSMTP();
$mail -> Host = 'smtp.gmail.com';
$mail -> SMTPAuth = true;
$mail -> Username = 'eddinebenhammou@gmail.com';
$mail -> Password = 'afpsqmlzmzmwovzw ';
$mail -> SMTPSecure = 'ssl';
$mail -> Port = 465;

$mail -> setFrom('eddinebenhammou@gmail.com');

$mail -> isHTML(true);
$mail -> Subject = 'Recuperation mot de passe';

// Fonction pour générer un code aléatoire
function genererCodeAleatoire($longueur = 8) {
    $caracteres = '0123456789';
    $lettres = 'abcdefghijklmnopqrstuvwxyz';
    $symboles = '@/.;()';
    $code = '';

    // Calculer le nombre de caractères à choisir pour les symboles
    $longueur_symboles = ceil($longueur / 4);

    // Ajouter les symboles au code
    for ($i = 0; $i < $longueur_symboles; $i++) {
        $code .= $symboles[rand(0, strlen($symboles) - 1)];
    }

    // Remplir le reste de la longueur avec des caractères et des lettres alternés
    $longueur_restante = $longueur - $longueur_symboles;
    for ($i = 0; $i < $longueur_restante; $i++) {
        if ($i % 2 == 0) {
            $code .= $caracteres[rand(0, strlen($caracteres) - 1)];
        } else {
            $code .= $lettres[rand(0, strlen($lettres) - 1)];
        }
    }

    // Mélanger le code pour rendre les symboles répartis de manière aléatoire
    $code = str_shuffle($code);
    return $code;
}


$db = mysqli_connect("localhost", "new_user", "password", "myPodDB");
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = mysqli_real_escape_string($db, htmlspecialchars($_POST['email']));

    // Vérifier si l'email existe dans la base de données
    $requeteEmailExiste = "SELECT * FROM Medecins WHERE Email = '$email'";
    $resultatEmailExiste = mysqli_query($db, $requeteEmailExiste);
    $rowEmailExiste = mysqli_fetch_assoc($resultatEmailExiste);

    if ($rowEmailExiste) {
        // Générer un code aléatoire
        $code = genererCodeAleatoire();

        // Enregistrement du code dans la base de données
        $requeteEnregistrementCode = "UPDATE Medecins SET motdepasse = '$code' WHERE Email = '$email'";
        mysqli_query($db, $requeteEnregistrementCode);


        // Envoyer le code par e-mail (vous devez configurer cela en fonction de votre serveur)
        $sujet = "Réinitialisation de mot de passe";
       
         $message = 
        '
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <title>Réinitialisation de mot de passe</title>
        </head>
        <body>
            <p> Votre code de réinitialisation de mot de passe est :<strong>'.$code.'</strong></p>
            <a href="index.php">Retour au site</a>
        </body>
        </html>
        
            ';
        $headers = "From: test@dine.local";
        $mail -> addAddress($email);
        $mail -> Body =$message;
        $mail -> send();
    
        echo "Un code de réinitialisation a été envoyé à l'adresse e-mail: ".$email;
    } else {
        echo "L'adresse e-mail n'est pas enregistrée dans notre système.";
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Réinitialisation de mot de passe - MyPod</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="style.css" />
</head>
<body>
    <div class="container">
        <div class="login-form">
            <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="POST">
                <h1>Réinitialisation de mot de passe</h1>
                <div class="form-group">
                    <label for="email">Adresse E-mail :</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <button type="submit">Envoyer le code de réinitialisation</button>
                <div class="form-footer">
                    <a href="index.php">Retour à la page de connexion</a>
                </div>
            </form>
            <?php if(isset($message)) echo "<p class='message'>$message</p>"; ?>
        </div>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</body>
</html>

