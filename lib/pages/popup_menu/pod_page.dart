import 'package:flutter/material.dart';
import 'package:mypod/utils/image_constant.dart';

class PodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulation des données factices pour l'exemple
    bool isConnected = true;
    double insulinRemaining = 150.0; // en unités
    int podLifetimeRemaining = 2; // en jours

    return Scaffold(
      appBar: AppBar(
        title: Text('Pod'),
      ),
      body: Center(
        child: Container(
          // Utiliser un Container pour ajouter un panneau
          padding: EdgeInsets.all(32.0), // Ajout  d'un espacement intérieur
          margin: EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: ImageConstant.violet.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.0), // Coins arrondis
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color: isConnected ? ImageConstant.violet : Colors.red,
                size: 64.0,
              ),
              SizedBox(height: 10.0),
              Text(
                isConnected ? 'Connecté' : 'Déconnecté',
                style: TextStyle(
                  fontSize: 24.0,
                  color: isConnected ? ImageConstant.violet : Colors.red,
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
      ),
    );
  }
}
