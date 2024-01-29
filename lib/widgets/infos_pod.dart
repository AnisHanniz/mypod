import 'package:flutter/material.dart';
import 'package:mypod/widgets/BasalRateChart.dart';
import 'package:mypod/pages/state_pod.dart';

class InfosPod {
  String name;
  Color boxColor;
  Widget? widget; // Ajout d'une propriété facultative pour un widget

  InfosPod({
    required this.name,
    required this.boxColor,
    this.widget, // Ajout du widget au constructeur
  });

  static List<InfosPod> getInfosPod(int i) {
    List<InfosPod> infos = [];
    switch (i) {
      case 0:
        infos.add(InfosPod(
          name: 'Résumé Général',
          boxColor: Color.fromARGB(255, 143, 26, 253),
          widget: null,
        ));
        break;

      case 1:
        infos.add(InfosPod(
          name: 'Profil Basal Actif',
          boxColor: Color.fromARGB(255, 143, 26, 253),
          widget: BasalRateChart(),
        ));
        break;

      case 2:
        infos.add(InfosPod(
            name: 'État du pod',
            boxColor: Color.fromARGB(255, 143, 26, 253),
            widget: StatePod(
              isConnected:
                  false, // 'isBluetoothConnected' est une variable booléenne représentant l'état de la connexion
            )));
        break;
      case 3:
        infos.add(InfosPod(
          name: 'Dernier Bolus',
          boxColor: Color.fromARGB(255, 143, 26, 253),
          widget: null,
        ));
        break;
      default:
        // Optionnel: Gérer le cas où 'i' n'est pas 1, 2 ou 3
        break;
    }
    return infos;
  }
}
