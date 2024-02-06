import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/pages/home.dart';
import 'package:sqflite/sqflite.dart';

class BolusInputDialog extends StatefulWidget {
  final double insulinRemaining;
  final Function(double) updateInsulinRemaining;

  BolusInputDialog({
    required this.insulinRemaining,
    required this.updateInsulinRemaining,
  });

  @override
  _BolusInputDialogState createState() => _BolusInputDialogState();
}

class _BolusInputDialogState extends State<BolusInputDialog> {
  double bolusAmount = 0.0;
  bool bolusInProgress = false;
  double bolusProgress = 0.0;
  final double bolusSpeed = 0.1; // Vitesse du bolus (à ajuster)

  Database? db;
  @override
  void initState() {
    super.initState();
    DatabaseProvider().initDB().then((database) {
      setState(() {
        db = database;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Entrez la quantité', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              bolusAmount = double.tryParse(value) ?? 0.0;
            },
          ),
          if (bolusInProgress)
            LinearProgressIndicator(
              value: bolusProgress,
              minHeight: 10,
            ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centre les boutons horizontalement
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: bolusInProgress
                    ? null
                    : () {
                        if (bolusAmount <= 0) {
                          _showInvalidValueDialog();
                        } else if (bolusAmount > widget.insulinRemaining) {
                          _showInsufficientInsulinDialog();
                        } else {
                          _startBolus();
                        }
                      },
                child: Text('OK'),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showInvalidValueDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Valeur invalide'),
          content: Text('Veuillez entrer une quantité de bolus valide.'),
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
  }

  void _showInsufficientInsulinDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pas assez d\'insuline restante'),
          content:
              Text('L\'insuline restante n\'est pas suffisante pour un bolus.'),
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
  }

  void _startBolus() async {
    if (db == null) {
      // Gestion cas où la base de données n'est pas initialisée
      print("La base de données n'est pas initialisée correctement.");
      return;
    }

    setState(() {
      bolusInProgress = true;
    });

    double remaining = widget.insulinRemaining;
    final double targetRemaining = remaining - bolusAmount;

    const updateInterval = Duration(milliseconds: 100);
    final totalSteps = ((bolusAmount / bolusSpeed) * 10).toInt();

    Future<void> updateProgress() async {
      if (remaining > targetRemaining) {
        setState(() {
          bolusProgress = 1.0 - (remaining - targetRemaining) / bolusAmount;
        });
        remaining -= bolusSpeed;
        Future.delayed(updateInterval, updateProgress);
      } else {
        setState(() {
          bolusProgress = 1.0;
        });

        // Mettre à jour l'historique des injections de bolus ici
        String dateInjection = DateFormat('dd-MM-yyyy').format(DateTime.now());
        String heureInjection = DateFormat.Hm().format(DateTime.now());

        double quantiteInjectee = bolusAmount;
        DatabaseProvider databaseProvider = DatabaseProvider();
        await databaseProvider.insertHistoriqueInjectionsBolusTable(
          db!,
          dateInjection,
          heureInjection,
          quantiteInjectee,
        );

        widget.updateInsulinRemaining(targetRemaining);

        // Fermer la boîte de dialogue
        Navigator.of(context).pop();

        // Redirection vers la page d'accueil (HomePage)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }

    updateProgress();
  }
}
