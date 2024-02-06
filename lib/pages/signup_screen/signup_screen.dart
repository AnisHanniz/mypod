import 'package:flutter/material.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/custom_elevated_button.dart';
import 'package:mypod/widgets/custom_image_view.dart';
import 'package:mypod/widgets/custom_text_form_field.dart';
import 'package:mypod/utils/image_constant.dart';

class FirstConnectionScreen extends StatelessWidget {
  FirstConnectionScreen({Key? key}) : super(key: key);

<<<<<<< Updated upstream
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController socialSecurityController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController treatingDoctorController =
      TextEditingController();
  final TextEditingController diabeticDoctorController =
      TextEditingController();
=======
  final TextEditingController idController = TextEditingController();
>>>>>>> Stashed changes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
<<<<<<< Updated upstream
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildPageTitle(context),
            SizedBox(height: 20),
            _buildFullName(context),
            SizedBox(height: 12),
            _buildEmail(context),
            SizedBox(height: 12),
            _buildSocialSecurity(context),
            SizedBox(height: 12),
            _buildBirthDate(context),
            SizedBox(height: 12),
            _buildTreatingDoctor(context),
            SizedBox(height: 12),
            _buildDiabeticDoctor(context),
            SizedBox(height: 12),
            _buildPassword(context),
            SizedBox(height: 12),
            _buildPassword1(context),
            SizedBox(height: 30),
            _buildSignUp(context),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () => onTapTxtHaveAnAccount(context),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Vous avez déjà un compte?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: "Se Connecter",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ImageConstant.violet,
=======
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              _buildPageTitle(context),
              const SizedBox(height: 29),
              _buildIDField(context),
              const SizedBox(height: 39),
              _buildConnectButton(context),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => onTapTxtHaveAnAccount(context),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Vous avez déjà un compte?",
                        style: TextStyle(color: Colors.black),
>>>>>>> Stashed changes
                      ),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: "Se Connecter",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ImageConstant.violet,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context) {
<<<<<<< Updated upstream
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imageLogo,
          height: 100,
          width: 100,
        ),
        SizedBox(height: 15),
        Text(
          "Nouveau Compte",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Une demande sera envoyée",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSecurity(BuildContext context) {
    return CustomTextFormField(
      controller: socialSecurityController,
      hintText: "Numéro de sécurité sociale",
      prefix: Icon(Icons.security, color: Colors.grey),
    );
  }

  Widget _buildBirthDate(BuildContext context) {
    return CustomTextFormField(
      controller: birthDateController,
      hintText: "Date de Naissance",
      prefix: Icon(Icons.calendar_today, color: Colors.grey),
    );
  }

  Widget _buildTreatingDoctor(BuildContext context) {
    return CustomTextFormField(
      controller: treatingDoctorController,
      hintText: "Médecin traitant",
      prefix: Icon(Icons.medical_services, color: Colors.grey),
    );
  }

  Widget _buildDiabeticDoctor(BuildContext context) {
    return CustomTextFormField(
      controller: diabeticDoctorController,
      hintText: "Médecin diabétologue",
      prefix: Icon(Icons.medical_services, color: Colors.grey),
    );
  }

  Widget _buildFullName(BuildContext context) {
    return CustomTextFormField(
      controller: fullNameController,
      hintText: "Votre nom complet",
      prefix: Icon(Icons.person, color: Colors.grey),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Votre Mail",
      textInputType: TextInputType.emailAddress,
      prefix: Icon(Icons.email, color: Colors.grey),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      controller: passwordController,
      hintText: "Mot de Passe",
      textInputType: TextInputType.visiblePassword,
      prefix: Icon(Icons.lock, color: Colors.grey),
      obscureText: true,
=======
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imageLogo,
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 27),
          const Text(
            "C'est votre première connexion",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "Entrez l'identifiant donné par votre médecin",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
>>>>>>> Stashed changes
    );
  }

  Widget _buildIDField(BuildContext context) {
    return CustomTextFormField(
<<<<<<< Updated upstream
      controller: passwordController1,
      hintText: "Mot de Passe encore",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      prefix: Icon(Icons.lock, color: Colors.grey),
      obscureText: true,
=======
      controller: idController,
      hintText: "Identifiant",
      prefix: const Icon(Icons.person, color: Colors.grey),
      prefixConstraints: const BoxConstraints(maxHeight: 40),
>>>>>>> Stashed changes
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Se Connecter",
      onPressed: () {
<<<<<<< Updated upstream
        // À faire
=======
        // à implémenter
        String identifier = idController.text;
        if (isValidIdentifier(identifier)) {
          Navigator.pushNamed(context, AppRoutes.accueilScreen);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Erreur"),
                content: const Text("L'identifiant fourni est invalide."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
>>>>>>> Stashed changes
      },
    );
  }

  void onTapTxtHaveAnAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  bool isValidIdentifier(String identifier) {
    // à implémenter
    return true;
  }
}
