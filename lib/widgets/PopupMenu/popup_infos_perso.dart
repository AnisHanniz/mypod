import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/utils/app_constants.dart';

class InfosPerso extends StatefulWidget {
  const InfosPerso({super.key});

  @override
  _InfosPersoState createState() => _InfosPersoState();
}

class _InfosPersoState extends State<InfosPerso> {
  Map<String, dynamic>? _infosPersoData;
  late DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    _databaseProvider = DatabaseProvider();
    _fetchDataFromAPI();
  }

  Future<void> _fetchDataFromAPI() async {
    // Récupérer l'email de l'utilisateur depuis la base de données locale
    final db = await _databaseProvider.initDB();
    final String? userEmail = await _databaseProvider.getUserEmail();

    if (userEmail != null && userEmail.isNotEmpty) {
      final email =
          userEmail; // Pas besoin de userEmail[0]['email'] car userEmail est déjà une String
      // Effectuer la requête à l'API avec l'email de l'utilisateur
      final response = await http.post(
        Uri.parse(
            'https://mypodev.000webhostapp.com/API/patient.php?email=$email'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _infosPersoData =
              data; // Stocker la réponse JSON dans _infosPersoData
        });
      } else {
        throw Exception('Erreur de communication avec l\'API');
      }
    } else {
      throw Exception(
          'Aucun utilisateur trouvé dans la base de données locale');
    }
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Informations Personnelles',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppConstants.violet.withOpacity(0.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10.0),
              _infosPersoData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoCard(
                          'Nom',
                          _infosPersoData!['Nom'],
                        ),
                        _buildInfoCard(
                          'Prénom',
                          _infosPersoData!['Prenom'],
                        ),
                        _buildInfoCard(
                          'Email',
                          _infosPersoData!['Email'],
                        ),
                        _buildInfoCard(
                          'Date de Naissance',
                          _infosPersoData!['DateDeNais'],
                        ),
                        _buildInfoCard(
                          'Adresse',
                          _infosPersoData!['Adresse'],
                        ),
                        _buildInfoCard(
                          'Numéro de Téléphone',
                          _infosPersoData!['NumeroTel'],
                        ),
                        // Ajoutez les autres champs que vous souhaitez afficher
                      ],
                    )
                  : const Text('Aucune donnée disponible.'),
            ],
          ),
        ),
      ),
    );
  }
}
