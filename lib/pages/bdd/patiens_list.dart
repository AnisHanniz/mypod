import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);
  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  List<dynamic> patients = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost/bdd/bdd.php/?patients'));

    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body);
      });
    } else {
      throw Exception('Échec de la récupération des données');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Patients'),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(patients[index]['NomPren']),
            subtitle: Text(patients[index]['Email']),
          );
        },
      ),
    );
  }
}
