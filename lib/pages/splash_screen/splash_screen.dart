import 'package:flutter/material.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/custom_elevated_button.dart';
import 'package:mypod/widgets/custom_outlined_button.dart';
import 'package:mypod/utils/image_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MyPod',
              style: TextStyle(
<<<<<<< Updated upstream
                fontSize:
                    24, // Ajustez la taille de la police selon vos préférences
=======
                fontSize: 24,
>>>>>>> Stashed changes
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              ImageConstant.imageLogo,
              height: 150,
              width: 150,
            ),
            SizedBox(height: 60),
            CustomElevatedButton(
              text: "Se Connecter",
              onPressed: () {
                onTapLogin(context);
              },
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
<<<<<<< Updated upstream
              text: "Créer un Compte",
=======
              text: "Première Connexion",
>>>>>>> Stashed changes
              onPressed: () {
                onTapSignUp(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  onTapLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  onTapSignUp(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signupScreen);
  }
}
