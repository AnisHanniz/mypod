import 'package:flutter/material.dart';

class PodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulons des données factices pour l'exemple
    bool isConnected = true;
    double insulinRemaining = 150.0; // en unités
    int podLifetimeRemaining = 2; // en jours

    return Scaffold(
      appBar: AppBar(
        title: Text('Pod'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'État de la connexion:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              isConnected ? 'Connecté' : 'Déconnecté',
              style: TextStyle(
                fontSize: 24.0,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Quantité d\'insuline restante:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              '$insulinRemaining unités',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Durée de vie restante du pod:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              '$podLifetimeRemaining jours',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
