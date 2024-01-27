import 'package:flutter/material.dart';
import 'pages/home.dart'; // Assurez-vous que le chemin est correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialApp est maintenant au niveau de runApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HomeWidget(), // Enveloppe FutureBuilder dans un nouveau widget
    );
  }
}

class HomeWidget extends StatelessWidget {
  // Cette fonction simule une tâche asynchrone, par exemple, le chargement de données depuis une base de données ou une API
  Future<bool> loadData() async {
    // Remplacez ceci par votre logique de chargement de données
    await Future.delayed(Duration(seconds: 3));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loadData(), // Fournit la future tâche asynchrone
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Utilisez Scaffold pour fournir un context Material
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return HomePage();
        }
      },
    );
  }
}
