<?php 
session_start(); 
include("config.php"); 
error_reporting(E_ALL); 
ini_set('display_errors', 1); 
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Plateforme Médecins - MyPod</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="style.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <div class="container">
        <?php if(isset($_GET['erreur'])): ?>
            <?php
                $erreurMessages = [
                    1 => "Email ou mot de passe incorrect.",
                    2 => "Email ou mot de passe vide.",
                    'default' => "Une erreur inattendue s'est produite."
                ];
                $message = $erreurMessages[$_GET['erreur']] ?? $erreurMessages['default'];
                echo "<script>alert('$message')</script>";
            ?>
        <?php endif; ?>
        <div class="login-form">
            <h1>Bienvenue sur MyPod</h1>
            <form action="donneedeconnetion.php" method="POST">
                <div class="form-group">
                    <label for="email">Adresse E-mail :</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Mot de Passe :</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password" required>
                        <img src="password_eyes.png" onclick="togglePasswordVisibility()" class="toggle-password" id="togglePassword">
                    </div>
                </div>
                <button type="submit">Connexion</button>
                <div class="form-footer">
                    <a href="forget_password.php">*Mot de passe oublié ?</a><br><br>
                    <span>Pas encore inscrit ?<br> <a href="pagedinscription.php">Faites une demande !</a></span>
                </div>
            </form>
        </div>
    </div>
    <script>
        var isVisible = false;
        function togglePasswordVisibility() {
            var passwordInput = document.getElementById('password');
            var toggleButton = document.getElementById('togglePassword');
            if(isVisible) {
                passwordInput.type = 'password';
                toggleButton.src = 'password_eyes.png';
                isVisible = false;
            } else {
                passwordInput.type = 'text';
                toggleButton.src = 'password_eyes_open.png';
                isVisible = true;
            }
        }
        $(document).ready(function() {
            var isVisible = false;
            $('#togglePassword').click(function() {
                if(isVisible) {
                    $('#password').attr('type', 'password');
                    $('#togglePassword').attr('src', 'password_eyes.png');
                } else {
                    $('#password').attr('type', 'text');
                    $('#togglePassword').attr('src', 'password_eyes_open.png');
                }
                isVisible = !isVisible;
                $(this).toggleClass('view');
            });
             $('a[href^="#"]').click(function(event) {
        event.preventDefault();
        var target = $(this.getAttribute('href'));
        if (target.length) {
            $('html, body').stop().animate({
                scrollTop: target.offset().top
            }, 1000); // The duration of the scrolling animation
        }
    });
        });
    </script>
</body>
</html>

