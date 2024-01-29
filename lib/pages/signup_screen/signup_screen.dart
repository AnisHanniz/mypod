import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/custom_elevated_button.dart';
import 'package:mypod/widgets/custom_image_view.dart';
import 'package:mypod/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:mypod/utils/image_constant.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ImageConstant.violet,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            _buildPageTitle(context),
            SizedBox(height: 29),
            _buildFullName(context),
            SizedBox(height: 8),
            _buildEmail(context),
            SizedBox(height: 8),
            _buildPassword(context),
            SizedBox(height: 8),
            _buildPassword1(context),
            SizedBox(height: 39),
            _buildSignUp(context),
            SizedBox(height: 24), // Added some spacing
            GestureDetector(
              onTap: () => onTapTxtHaveAnAccount(context),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Vous avez déjà un compte?",
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: "Se Connecter",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imageLogo,
          height: 42,
          width: 115,
        ),
        SizedBox(height: 27),
        Text(
          "C'est parti!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Créer un nouveau compte",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFullName(BuildContext context) {
    return CustomTextFormField(
      controller: fullNameController,
      hintText: "Votre nom complet",
      prefix: Icon(Icons.person, color: Colors.grey),
      prefixConstraints: BoxConstraints(maxHeight: 40),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Votre Mail",
      textInputType: TextInputType.emailAddress,
      prefix: Icon(Icons.email, color: Colors.grey),
      prefixConstraints: BoxConstraints(maxHeight: 48),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      hintText: "Mot de Passe",
      textInputType: TextInputType.visiblePassword,
      prefix: Icon(Icons.lock, color: Colors.grey),
      prefixConstraints: BoxConstraints(maxHeight: 48),
      obscureText: true,
    );
  }

  Widget _buildPassword1(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController1,
      hintText: "Mot de Passe encore",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      prefix: Icon(Icons.lock, color: Colors.grey),
      prefixConstraints: BoxConstraints(maxHeight: 48),
      obscureText: true,
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return CustomElevatedButton(
      text: "Confirmer",
      onPressed: () {
        // Implement the sign-up logic here
      },
    );
  }

  void onTapTxtHaveAnAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }
}
