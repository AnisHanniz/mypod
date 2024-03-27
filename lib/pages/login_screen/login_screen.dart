import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypod/utils/app_constants.dart';
import 'package:mypod/utils/app_routes.dart';
import 'package:mypod/widgets/Custom_diWHise/custom_text_form_field.dart';

Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse(
        'https://mypodev.000webhostapp.com/api/auth/login.php'), // remove extra slashes
    body: {
      'Email': email, // use 'Email' instead of 'email'
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['success'];
  } else {
    throw Exception('Erreur de communication avec l\'API');
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey, // Add Form widget and assign _formKey
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                _buildPageTitle(),
                const SizedBox(height: 32),
                CustomTextFormField(
                  controller: emailController,
                  hintText: "Votre mail",
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Entrez un email valide';
                    }
                    return null;
                  },
                  prefix: const Icon(Icons.email, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Mot de Passe",
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le mot de passe ne peut pas être vide';
                    }
                    return null;
                  },
                  prefix: const Icon(Icons.lock, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            try {
                              bool success = await login(emailController.text,
                                  passwordController.text);
                              if (success) {
                                Navigator.pushNamed(
                                    context, AppRoutes.accueilScreen);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Échec de connexion')),
                                );
                              }
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erreur: $error')),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signupScreen);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Première connexion? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "S'enregistrer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.violet,
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
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      children: [
        Image.asset(
          AppConstants.imageLogo,
          height: 200,
          width: 200,
        ),
        const SizedBox(height: 26),
        const Text(
          "Bienvenue sur MyPod",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Se Connecter pour continuer",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
