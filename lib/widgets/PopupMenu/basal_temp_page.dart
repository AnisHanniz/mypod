import 'package:flutter/material.dart';

class BasalTempPage extends StatefulWidget {
  @override
  _BasalTempPageState createState() => _BasalTempPageState();
}

class _BasalTempPageState extends State<BasalTempPage> {
  TextEditingController durationController = TextEditingController();
  TextEditingController basalRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Définir Basal Temporaire'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Durée de profil basal temporaire (en heures):',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez la durée en heures',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Quantité basale d\'insuline (unités par heure):',
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: basalRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Entrez la quantité basale',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Récupérez les valeurs entrées par l'utilisateur
                double duration =
                    double.tryParse(durationController.text) ?? 0.0;
                double basalRate =
                    double.tryParse(basalRateController.text) ?? 0.0;

                // Vous pouvez maintenant utiliser ces valeurs pour créer le profil basal temporaire
                // Par exemple, vous pouvez les sauvegarder localement ou les envoyer à un serveur

                // Affichez un message de confirmation
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Profil Basal Temporaire Créé'),
                      content: Text(
                        'Durée: $duration heures\nQuantité basale: $basalRate unités par heure',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Créer Profil Basal Temporaire'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    durationController.dispose();
    basalRateController.dispose();
    super.dispose();
  }
}
