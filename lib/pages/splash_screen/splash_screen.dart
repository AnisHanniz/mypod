import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/custom_elevated_button.dart';
import 'package:mypod/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:mypod/utils/image_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ImageConstant.violet,
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 46),
                child: Column(children: [
                  Spacer(),
                  CustomOutlinedButton(
                      text: "Se Connecter",
                      margin: EdgeInsets.only(right: 6),
                      onPressed: () {
                        onTapLogin(context);
                      }),
                  SizedBox(height: 15),
                  CustomElevatedButton(
                      text: "Créer un Compte",
                      margin: EdgeInsets.only(right: 6),
                      onPressed: () {
                        onTapSignUp(context);
                      })
                ]))));
  }

  onTapLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  onTapSignUp(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signupScreen);
  }
}
