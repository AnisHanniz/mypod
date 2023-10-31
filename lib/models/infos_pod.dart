import 'package:flutter/material.dart';

class InfosPod {
  String name;
  String text; // Ajoutez la propriété text
  Color boxColor;

  InfosPod({
    required this.name,
    required this.text, // Ajoutez le texte ici
    required this.boxColor,
  });

  static List<InfosPod> getInfosPod() {
    List<InfosPod> infos = [];
    infos.add(InfosPod(
        name: 'Résumé Général',
        text: 'Tableau de Bord', // Ajoutez le texte ici
        boxColor: Color.fromARGB(255, 143, 26, 253)));
    infos.add(InfosPod(
        name: 'Informations pour le schéma basal actif',
        text: 'Schéma Basal', // Ajoutez le texte ici
        boxColor: Color.fromARGB(255, 143, 26, 253)));

    return infos;
  }
}
