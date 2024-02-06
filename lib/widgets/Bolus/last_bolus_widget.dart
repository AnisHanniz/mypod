import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LastBolusWidget extends StatefulWidget {
  @override
  _LastBolusWidgetState createState() => _LastBolusWidgetState();
}

class _LastBolusWidgetState extends State<LastBolusWidget> {
  String lastBolus = 'Aucun bolus enregistré';
  String dateInjection = 'Non disponible';
  String heureInjection = 'Non disponible';

  @override
  void initState() {
    super.initState();
    getLastBolusFromDatabase();
  }

  Future<void> getLastBolusFromDatabase() async {
    Database? database;
    try {
      database = await openDatabase(
        join(await getDatabasesPath(), 'local.db'),
      );

      final List<Map<String, dynamic>> results = await database.query(
        'historique_injections_bolus',
        orderBy: 'date_injection DESC, heure_injection DESC',
        limit: 1,
      );

      if (results.isNotEmpty) {
        setState(() {
          lastBolus = results[0]['dose']
              .toString(); // Remplacez 'dose' par le nom de votre colonne contenant la quantité de bolus
          dateInjection = results[0]['date_injection'];
          heureInjection = results[0]['heure_injection'];
        });
      } else {
        // Si la requête ne renvoie aucun résultat, vous pouvez gérer ce cas ici
        setState(() {
          lastBolus = 'Aucun bolus';
          dateInjection = 'Non disponible';
          heureInjection = 'Non disponible';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération du dernier bolus : $e');
      // Gérer les erreurs ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded), // Icône pour la date
              SizedBox(width: 4.0),
              Text(
                ' $lastBolus u',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today), // Icône pour la date
              SizedBox(width: 4.0),
              Text(
                ' $dateInjection',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time), // Icône pour l'heure
              SizedBox(width: 4.0),
              Text(
                ' $heureInjection',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
