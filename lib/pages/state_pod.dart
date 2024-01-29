import 'package:flutter/material.dart';

class StatePod extends StatelessWidget {
  final bool isConnected;

  const StatePod({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    Icon connectionIcon = isConnected
        ? const Icon(Icons.check_circle,
            color: Colors.white) // Icône pour l'état connecté
        : const Icon(Icons.error,
            color: Colors.black); // Icône pour l'état déconnecté

    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Pour s'assurer que l'espace pris est juste suffisant pour le contenu
        children: [
          connectionIcon, // Affichage de l'icône choisie
          Text(
            isConnected ? 'Connecté' : 'Déconnecté',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          )
          // Texte de l'état de la connexion
        ],
      ),
    );
  }
}
