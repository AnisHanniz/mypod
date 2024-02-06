import 'package:flutter/material.dart';
import 'package:mypod/pages/bdd/database.dart';

class DatabaseViewerScreen extends StatefulWidget {
  @override
  _DatabaseViewerScreenState createState() => _DatabaseViewerScreenState();
}

class _DatabaseViewerScreenState extends State<DatabaseViewerScreen> {
  late DatabaseProvider _databaseProvider;
  List<Map<String, dynamic>>? _loginsData;
  List<Map<String, dynamic>>? _notificationsData;
  List<Map<String, dynamic>>? _historiqueInjectionsData;
  List<Map<String, dynamic>>? _profilsBasauxData;
  List<Map<String, dynamic>>? _logsConnexionPodsData;
  Map<String, dynamic>? _utilisateurParamsData;

  @override
  void initState() {
    super.initState();
    _databaseProvider = DatabaseProvider();
    _fetchDataFromDatabase();
    _fetchUtilisateurParamsFromDatabase();
  }

  Future<void> _insertDummyData() async {
    final db = await _databaseProvider.initDB();
    await _databaseProvider.simulateData(db);
    _fetchDataFromDatabase(); // Mettre à jour les données après l'insertion
  }

  Future<void> _fetchUtilisateurParamsFromDatabase() async {
    final db = await _databaseProvider.initDB();
    final utilisateurParams = await db.query('utilisateur_params');

    if (utilisateurParams.isNotEmpty) {
      setState(() {
        _utilisateurParamsData = utilisateurParams[0];
      });
    }
  }

  Future<void> _fetchDataFromDatabase() async {
    final db = await _databaseProvider.initDB();

    final logins = await db.query('logins');
    final notifications = await db.query('notifications_et_rappels');
    final historiqueInjections = await db.query('historique_injections_bolus');
    final profilsBasaux = await db.query('profils_basaux_temporaires');
    final logsConnexionPods = await db.query('logs_connexion_pods');

    setState(() {
      _loginsData = logins;
      _notificationsData = notifications;
      _historiqueInjectionsData = historiqueInjections;
      _profilsBasauxData = profilsBasaux;
      _logsConnexionPodsData = logsConnexionPods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viewer de la Base de Données'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: _insertDummyData, // Appel de la fonction d'insertion
            child: Text('Insérer des données fictives'),
          ),
          ElevatedButton(
            onPressed:
                _fetchDataFromDatabase, // Bouton pour actualiser les données
            child: Text('Actualiser'),
          ),
          _buildTable('Table Logins', _loginsData),
          _buildTable('Table Notifications et Rappels', _notificationsData),
          _buildTable(
              'Table Historique Injections Bolus', _historiqueInjectionsData),
          _buildTable('Table Profils Basaux Temporaires', _profilsBasauxData),
          _buildTable('Table Logs Connexion Pods', _logsConnexionPodsData),
          if (_utilisateurParamsData != null)
            _buildTable(
                'Table Paramètres Utilisateur', [_utilisateurParamsData!]),
        ],
      ),
    );
  }

  Widget _buildTable(String title, List<Map<String, dynamic>>? data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (data != null && data.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  ...data[0]
                      .keys
                      .map((key) => DataColumn(label: Text(key)))
                      .toList(),
                  DataColumn(label: Text('Supprimer')),
                ],
                rows: data
                    .map((row) => DataRow(
                          cells: [
                            ...row.values
                                .map(
                                    (value) => DataCell(Text(value.toString())))
                                .toList(),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('-'),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          if (data == null || data.isEmpty) Text('Aucune donnée disponible.'),
        ],
      ),
    );
  }
}
