import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mypod/utils/app_constants.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_elevated_button.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_image_view.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_text_form_field.dart';

class FirstConnectionScreen extends StatelessWidget {
  FirstConnectionScreen({super.key});

  final TextEditingController emailController = TextEditingController();
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
              _buildEmailField(context),
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
                          color: AppConstants.violet,
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

  Widget _buildConnectButton(BuildContext context) {
    return CustomElevatedButton(
      text: "Se Connecter",
      onPressed: () async {
        try {
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            // Aucune connexion Internet
            _showDialog(context, "Pas de connexion Internet",
                "Veuillez vous connecter à Internet pour continuer.");
            return;
          }

          // Implémentation de l'envoi de l'email et du mot de passe
          String identifier = emailController.text;
          if (isValidEmail(identifier)) {
            bool emailSent = await sendEmailWithPassword(identifier);
            if (emailSent) {
              // Email envoyé avec succès
              _showDialog(context, "Email envoyé",
                  "Veuillez vérifier votre boîte de réception pour le mot de passe.");
              // Redirection vers l'écran de connexion peut être ici
            } else {
              // Échec de l'envoi de l'email
              _showDialog(context, "Erreur",
                  "Impossible d'envoyer l'email. Veuillez réessayer.");
            }
          } else {
            _showDialog(context, "Erreur", "L'email fourni est invalide.");
          }
        } catch (e) {
          print("Erreur lors de la vérification de la connectivité : $e");
          _showDialog(context, "Erreur",
              "Impossible de vérifier l'état de la connexion Internet.");
        }
      },
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  // À implémenter selon votre backend
  Future<bool> sendEmailWithPassword(String identifier) async {
    // Envoyez la requête à votre API ici
    // Gérez la réponse et retournez true si l'email a été envoyé, false sinon
    return true; // Exemple
  }

  Widget _buildPageTitle(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: AppConstants.imageLogo,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 5),
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
            "Entrez votre email",
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

  Widget _buildEmailField(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Email",
      prefix: const Icon(Icons.person, color: Colors.grey),
      prefixConstraints: const BoxConstraints(maxHeight: 40),
    );
  }

  void onTapTxtHaveAnAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  bool isValidEmail(String email) {
    // Expression régulière pour la validation d'email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    return emailRegex.hasMatch(email);
  }
}
