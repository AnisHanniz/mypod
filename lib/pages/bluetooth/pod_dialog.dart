import 'package:flutter/material.dart';
import 'package:mypod/pages/bluetooth/new_bluetooth.dart';

void showChangePodDialog(BuildContext context, Function launchBluetoothState) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Changer mon Pod"),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("1. Veuillez retirer puis éliminer votre Pod actuel."),
            Text("2. Veuillez mettre le nouveau pod en 'Mode Recherche'."),
            Text("3. Sélectionner le bon périphérique à appairer."),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(Duration.zero, () {
                launchBluetoothState(context);
              });
            },
            child: const Text("Suivant"),
          ),
        ],
      );
    },
  );
}

void launchBluetoothState(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const FlutterBlueApp(),
    ),
  );
}
