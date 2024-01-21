import 'package:flutter/material.dart';

class BasalProfile {
  List<BasalRate> rates;

  BasalProfile(this.rates);

  double calculateBasalInsulinForTime(TimeOfDay time) {
    // Parcourt les taux basaux pour trouver la plage horaire correspondante
    for (final rate in rates) {
      if (time.hour > rate.startTime.hour && time.hour < rate.endTime.hour) {
        // Calcule la quantité d'insuline basale
        return rate.rate / 60.0; // Le taux est par heure, donc on divise par 60
      }
    }
    // Si aucune plage horaire ne correspond, retourne 0
    return 0.0;
  }
}

class BasalRate {
  TimeOfDay startTime;
  TimeOfDay endTime;
  double rate;

  BasalRate(this.startTime, this.endTime, this.rate);
}

class BasalProfileEditor extends StatefulWidget {
  @override
  _BasalProfileEditorState createState() => _BasalProfileEditorState();
}

class _BasalProfileEditorState extends State<BasalProfileEditor> {
  List<BasalRate> rates = [];

  // Méthode pour ajouter un taux basal
  void addBasalRate() {
    setState(() {
      rates.add(BasalRate(TimeOfDay.now(), TimeOfDay.now(), 0.0));
    });
  }

  // Méthode pour supprimer un taux basal
  void deleteBasalRate(int index) {
    setState(() {
      rates.removeAt(index);
    });
  }

  // Méthode pour mettre à jour les heures de début
  void updateStartTime(TimeOfDay newTime, int index) {
    setState(() {
      rates[index].startTime = newTime;
    });
  }

  // Méthode pour mettre à jour les heures de fin
  void updateEndTime(TimeOfDay newTime, int index) {
    setState(() {
      rates[index].endTime = newTime;
    });
  }

  // Méthode pour mettre à jour le taux d'insuline
  void updateInsulinRate(double newRate, int index) {
    setState(() {
      rates[index].rate = newRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Profils Basaux'),
      ),
      body: ListView.builder(
        itemCount: rates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Plage horaire ${index + 1}'),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text('De '),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: rates[index].startTime,
                          context: context,
                        );
                        updateStartTime(selectedTime!, index);
                      },
                      child: Text(rates[index].startTime.format(context)),
                    ),
                    Text('à'),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          initialTime: rates[index].endTime,
                          context: context,
                        );
                        updateEndTime(selectedTime!, index);
                      },
                      child: Text(rates[index].endTime.format(context)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Taux d\'insuline: '),
                    Flexible(
                      child: TextField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        onChanged: (newRate) {
                          updateInsulinRate(double.parse(newRate), index);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteBasalRate(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBasalRate,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BasalProfileEditor(),
  ));
}
