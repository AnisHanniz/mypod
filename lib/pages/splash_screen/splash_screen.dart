import 'package:flutter/material.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_elevated_button.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_outlined_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              AppConstants.imageLogo,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 60),
            CustomElevatedButton(
              text: "Se Connecter",
              onPressed: () {
                onTapLogin(context);
              },
            ),
            const SizedBox(height: 20),
            CustomOutlinedButton(
              text: "Première Connexion",
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
