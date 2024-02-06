import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/custom_elevated_button.dart';
import 'package:mypod/widgets/custom_image_view.dart';
import 'package:mypod/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:mypod/utils/image_constant.dart';

class FirstConnectionScreen extends StatelessWidget {
  FirstConnectionScreen({Key? key}) : super(key: key);

  final TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    );
  }

  Widget _buildIDField(BuildContext context) {
    return CustomTextFormField(
      controller: idController,
      hintText: "Identifiant",
      prefix: const Icon(Icons.person, color: Colors.grey),
      prefixConstraints: const BoxConstraints(maxHeight: 40),
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Se Connecter",
      onPressed: () {
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
