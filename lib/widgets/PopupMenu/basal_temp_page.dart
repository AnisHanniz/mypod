import 'package:flutter/material.dart';
import 'package:mypod/utils/image_constant.dart';

class BasalTempPage extends StatefulWidget {
  @override
  _BasalTempPageState createState() => _BasalTempPageState();
}

class _BasalTempPageState extends State<BasalTempPage> {
  double selectedDuration = 0.25;
  TextEditingController basalRateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Définir Basal Temporaire'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: ImageConstant.violet.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10.0), // Coins arrondis
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Durée de profil basal temporaire:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    DropdownButton<double>(
                      value: selectedDuration,
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value!;
                        });
                      },
                      items: [
                        const DropdownMenuItem<double>(
                          value: 0.25,
                          child: Text('15 minutes'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 0.5,
                          child: Text('30 minutes'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 0.75,
                          child: Text('45 minutes'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 1.0,
                          child: Text('1 heure'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 1.5,
                          child: Text('1 heure 30 min'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 2.0,
                          child: Text('2 heures'),
                        ),
                        const DropdownMenuItem<double>(
                          value: 3.0,
                          child: Text('3 heures'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Quantité basale d\'insuline (unités par heure):',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    TextFormField(
                      controller: basalRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Entrez la quantité basale',
                      ),
                      validator: (value) {
                        // ...
                      },
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            const SizedBox(
                height: 50.0), // Espace entre le formulaire et le bouton
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    double basalRate =
                        double.tryParse(basalRateController.text) ?? 0.0;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Basal Temporaire Créé'),
                          content: Text(
                            'Durée: ${selectedDuration.toStringAsFixed(2)} heures\nQuantité basale: ${basalRate.toStringAsFixed(2)} unités par heure\n\n\nConfirmer?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Oui'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Non'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Créer Profil Basal Temporaire'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    basalRateController.dispose();
    super.dispose();
  }
}
