import 'package:flutter/material.dart';
import 'package:mypod/widgets/BasalRateChart.dart';
<<<<<<< Updated upstream
import 'package:mypod/widgets/state_pod.dart';
import 'package:mypod/widgets/resume_general.dart';
=======
import 'package:mypod/pages/state_pod.dart';
import 'package:mypod/widgets/Bolus/last_bolus_widget.dart';
import 'package:mypod/widgets/resume_general.dart';
import 'package:sqflite/sqflite.dart';
>>>>>>> Stashed changes

class InfosPod {
  String name;
  Color boxColor;
  Widget? widget;
<<<<<<< Updated upstream
=======
  Database database;
>>>>>>> Stashed changes

  InfosPod({
    required this.name,
    required this.boxColor,
<<<<<<< Updated upstream
=======
    required this.database,
>>>>>>> Stashed changes
    this.widget,
  });

  Widget buildWidget() {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

<<<<<<< Updated upstream
  static List<InfosPod> getInfosPod(int i) {
=======
  static List<InfosPod> getInfosPod(int i, Database db) {
>>>>>>> Stashed changes
    List<InfosPod> infos = [];

    switch (i) {
      case 0:
        infos.add(InfosPod(
          name: 'Résumé Général',
          boxColor: Color.fromARGB(255, 143, 26, 253),
<<<<<<< Updated upstream
          widget: ResumeGeneralCard(
            // Simulation de valeurs
            lastBolus: 10.0,
            lastBolusTime: DateTime.now(),
            currentBasalRate: 1.0,
            datechangementPod: DateTime.now(),
          ),
=======
          database: db, // Pass the database object here
          widget: ResumeGeneralCard(database: db),
>>>>>>> Stashed changes
        ));
        break;

      case 1:
        infos.add(InfosPod(
          name: '',
          boxColor: Color.fromARGB(255, 143, 26, 253),
          widget: BasalRateChart(),
          database: db,
        ));
        break;

      case 2:
        infos.add(InfosPod(
            name: 'État du pod',
            boxColor: Color.fromARGB(255, 143, 26, 253),
            widget: StatePod(
              isConnected:
                  true, // 'isBluetoothConnected' est une variable booléenne représentant l'état de la connexion
            ),
            database: db));
        break;
      case 3:
        infos.add(InfosPod(
          name: 'Dernier Bolus',
          boxColor: Color.fromARGB(255, 143, 26, 253),
          widget: LastBolusWidget(),
          database: db,
        ));
        break;
      default:
        // Gérer le cas où 'i' n'est pas 1, 2 ou 3
        break;
    }
    return infos;
  }
}
