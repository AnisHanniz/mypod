import 'package:flutter/material.dart';
import 'package:mypod/widgets/BasalRateChart.dart';
import 'package:mypod/widgets/Bolus/last_bolus_widget.dart';
import 'package:mypod/widgets/resume_general.dart';
import 'package:mypod/widgets/state_pod.dart';
import 'package:sqflite/sqflite.dart';

class InfosPod {
  String name;
  Color boxColor;
  Widget? widget;
  Database database;

  InfosPod({
    required this.name,
    required this.boxColor,
    required this.database,
    this.widget,
  });

  Widget buildWidget() {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static List<InfosPod> getInfosPod(int i, Database db) {
    List<InfosPod> infos = [];

    switch (i) {
      case 0:
        infos.add(InfosPod(
          name: 'Résumé Général',
          boxColor: const Color.fromARGB(255, 143, 26, 253),
          database: db,
          widget: ResumeGeneralCard(database: db),
        ));
        break;

      case 1:
        infos.add(InfosPod(
          name: '',
          boxColor: const Color.fromARGB(255, 143, 26, 253),
          widget: const BasalRateChart(),
          database: db,
        ));
        break;

      case 2:
        infos.add(InfosPod(
            name: 'État du pod',
            boxColor: const Color.fromARGB(255, 143, 26, 253),
            widget: const StatePod(),
            database: db));
        break;
      case 3:
        infos.add(InfosPod(
          name: 'Dernier Bolus',
          boxColor: const Color.fromARGB(255, 143, 26, 253),
          widget: const LastBolusWidget(),
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
