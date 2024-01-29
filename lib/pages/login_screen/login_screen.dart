import 'package:flutter/material.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/utils/image_constant.dart';
import 'package:mypod/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ImageConstant.violet,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              _buildPageTitle(context),
              SizedBox(height: 32),
              CustomTextFormField(
                controller: emailController,
                hintText: "Votre mail",
                textInputType: TextInputType.emailAddress,
                prefix: Icon(Icons.email, color: Colors.grey),
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                controller: passwordController,
                hintText: "Mot de Passe",
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
                prefix: Icon(Icons.lock, color: Colors.grey),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  onTapSignIn(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 14), // Ajusté le padding
                  minimumSize:
                      Size(double.infinity, 50), // Ajusté la taille du bouton
                ),
                child: Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  onTapTxtDontHaveAnAccount(context);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Vous n'avez pas de compte?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(text: " "),
                      TextSpan(
                        text: "S'enregistrer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          ImageConstant.imageLogo,
          height: 42,
          width: 115,
        ),
        SizedBox(height: 26),
        Text(
          "Bienvenue sur MyPod",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Se Connecter pour continuer",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void onTapSignIn(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signupScreen);
  }

  void onTapTxtDontHaveAnAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.signupScreen);
  }
}
