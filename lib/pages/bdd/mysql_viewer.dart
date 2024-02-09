import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MySQLViewer extends StatefulWidget {
  @override
  _MySQLViewerState createState() => _MySQLViewerState();
}

class _MySQLViewerState extends State<MySQLViewer> {
  late MySqlConnection _connection;
  bool _isLoading = true;
  late List<Map<String, dynamic>> _data;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      _connection = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'deesse90',
        db: 'myPodDB',
      ));
      final results = await _connection.query('SELECT * FROM Medecins');
      setState(() {
        _isLoading = false;
        _data = results.toList().cast<Map<String, dynamic>>();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors de la connexion à la base de données : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySQL Viewer'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage),
                )
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final row = _data[index];
                    return ListTile(
                      title: Text(
                          'ID: ${row['MedecinID']}, Nom: ${row['nom']}, Prénom: ${row['prenom']}, Spécialité: ${row['Specialite']}, Numéro de téléphone: ${row['NumeroTel']}, Email: ${row['Email']}'),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _connection.close();
    super.dispose();
  }
}
