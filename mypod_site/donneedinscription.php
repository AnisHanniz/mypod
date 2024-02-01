
 <?php
try{

  $connexion = mysqli_connect("localhost", "new_user", "password", "myPodDB");
  $nom= mysqli_real_escape_string($connexion,htmlspecialchars($_POST["nom"]));
  $prenom= mysqli_real_escape_string($connexion,htmlspecialchars($_POST["prenom"]));
  $pseudo= mysqli_real_escape_string($connexion,htmlspecialchars($_POST["pseudo"]));
  $email= mysqli_real_escape_string($connexion,htmlspecialchars($_POST["email"]));
  $password= mysqli_real_escape_string($connexion,htmlspecialchars($_POST["password"]));

  //On lance une recherche dans la bdd avec les infos recus pour s'assurer que le pseudo l'email ne sont pas deja utilisé);
  $requete="SELECT * from registre where adressemail = '$email' OR pseudo = '$pseudo' ";  
  $res = mysqli_query($connexion, $requete);   
  $resultat =  mysqli_fetch_array($res);
 
  if($resultat!=0){
     header('Location: pagedinscription.php'); 
  } else {
    $requete="INSERT INTO registre (nom, prenom, adressemail, motdepasse, pseudo) VALUES ('$nom','$prenom','$email','$password', '$pseudo')";
    mysqli_query($connexion,$requete);  
    $requete = "SELECT * FROM registre WHERE adressemail = '$email'";
    $res = mysqli_query($connexion, $requete); 
    while($row = mysqli_fetch_array($res))  {
      $id_user = $row['id'];
      $connect = mysqli_connect("localhost", "new_user", "password", "myPodDB");
        $ferie = 2;
        $samedi = 1;
        $dimanche = 0;
        $affichage = 0;
        $limit = 7;
        $requete = "INSERT INTO preference VALUES('$samedi','$dimanche','$ferie', '$limit','$affichage','$id_user')";
        mysqli_query($connect, $requete);
        echo mysqli_error($connect);
        mysqli_close($connect);
    }
    header('Location: index.php');
    mysqli_close($connexion);
 }
}
catch(PDOException $e){
  die('Erreur :'.$e->getMessage());
}
 ?> 

