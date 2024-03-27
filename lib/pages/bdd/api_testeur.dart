import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTester extends StatefulWidget {
  const ApiTester({super.key});

  @override
  State<ApiTester> createState() => _ApiTesterState();
}

class _ApiTesterState extends State<ApiTester> {
  final TextEditingController _resultController = TextEditingController();

  Future<void> fetchInfosPatient() async {
    // Mettez à jour cette fonction pour récupérer les informations du patient
    final response = await http.get(
        Uri.parse('https://mypodev.000webhostapp.com/API/patient.php?id=1'));
    if (response.statusCode == 200) {
      // Supposons que vous voulez afficher le corps de la réponse
      _resultController.text = response.body;
    } else {
      _resultController.text =
          'Erreur lors de la récupération des infos patient.';
    }
  }

  Future<void> fetchTraitementPatient() async {
    // Mettez à jour cette fonction pour récupérer les traitements du patient
    final response =
        await http.get(Uri.parse('Votre_URL_pour_les_traitements_patient'));
    if (response.statusCode == 200) {
      _resultController.text = response.body;
    } else {
      _resultController.text =
          'Erreur lors de la récupération des traitements patient.';
    }
  }

  Future<void> fetchMdpGenere() async {
    // Mettez à jour cette fonction pour récupérer le mot de passe généré
    final response =
        await http.get(Uri.parse('Votre_URL_pour_le_mot_de_passe_généré'));
    if (response.statusCode == 200) {
      _resultController.text = response.body;
    } else {
      _resultController.text =
          'Erreur lors de la récupération du mot de passe généré.';
    }
  }

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testeur d\'API'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: fetchInfosPatient,
              child: const Text('Infos Patient'),
            ),
            ElevatedButton(
              onPressed: fetchTraitementPatient,
              child: const Text('Traitement Patient'),
            ),
            ElevatedButton(
              onPressed: fetchMdpGenere,
              child: const Text('MDP Généré'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _resultController,
              maxLines:
                  null, // Permet au TextField de s'étendre sur plusieurs lignes
              decoration: const InputDecoration(
                labelText: 'Résultat',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Rend le TextField en lecture seule
            ),
          ],
        ),
      ),
    );
  }
}
