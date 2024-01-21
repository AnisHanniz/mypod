import 'package:mypod/models/bluetooth_manager.dart';
import 'package:mypod/pages/authManager.dart';
import 'package:mypod/pages/home.dart';
import 'package:flutter/material.dart';

class SetupPasswordPage extends StatefulWidget {
  @override
  _SetupPasswordPageState createState() => _SetupPasswordPageState();
}

class _SetupPasswordPageState extends State<SetupPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sécurité : '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Veuillez entrer votre Mot de Passe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de Passe',
                hintText: 'Entrez votre Mot de Passe',
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmation Mot de Passe',
                hintText: 'Confirmez votre Mot de Passe',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique setup password à implémenter
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (password == confirmPassword) {
                  // Tout est bon
                  AuthManager().setPassword(password);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              bluetoothManager: BluetoothManager(),
                            )),
                  );
                } else {
                  // erreur, les mots de passes ne match pas
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Vos mots de passe ne sont pas identiques.'),
                    ),
                  );
                }
              },
              child: Text('Setup Mot de Passe'),
            ),
          ],
        ),
      ),
    );
  }
}
