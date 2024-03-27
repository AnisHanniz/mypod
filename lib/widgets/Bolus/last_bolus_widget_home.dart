import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LastBolusWidget extends StatefulWidget {
  const LastBolusWidget({super.key});

  @override
  _LastBolusWidgetState createState() => _LastBolusWidgetState();
}

class _LastBolusWidgetState extends State<LastBolusWidget> {
  String lastBolus = 'Aucun bolus enregistré';
  String dateInjection = '';
  String heureInjection = '';

  @override
  void initState() {
    super.initState();
    getLastBolusFromDatabase(); // Appel de la fonction pour récupérer le dernier bolus
  }

  Future<void> getLastBolusFromDatabase() async {
    try {
      Database database = await openDatabase(
        join(await getDatabasesPath(), 'local.db'),
      );

      final List<Map<String, dynamic>> results = await database.query(
        'historique_injections_bolus',
        orderBy: 'date_injection ASC, heure_injection ASC',
        limit: 1,
      );

      if (results.isNotEmpty) {
        setState(() {
          lastBolus = results[0]['dose'].toString();
          dateInjection = results[0]['date_injection'];
          heureInjection = results[0]['heure_injection'];
        });
      } else {}
    } catch (e) {
      print('Erreur lors de la récupération du dernier bolus : $e');
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
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt_rounded), // Icône pour la date
              const SizedBox(width: 4.0),
              Text(
                '$lastBolus unités',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today), // Icône pour la date
              const SizedBox(width: 4.0),
              Text(
                'le $dateInjection',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0), // Espace entre les icônes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time), // Icône pour l'heure
              const SizedBox(width: 4.0),
              Text(
                'à $heureInjection',
                style: const TextStyle(
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
