import 'package:flutter/material.dart';
import 'package:mypod/pages/bdd/database.dart';
import 'package:mypod/utils/app_constants.dart';

class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  HistoriqueState createState() => HistoriqueState();
}

class HistoriqueState extends State<Historique> {
  List<Map<String, dynamic>>? _historiqueInjectionsData;
  late DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    _databaseProvider = DatabaseProvider();
    _fetchDataFromDatabase();
  }

  Future<void> _fetchDataFromDatabase() async {
    final db = await _databaseProvider.initDB();
    final historiqueInjections = await db.query('historique_injections_bolus');
    setState(() {
      _historiqueInjectionsData = historiqueInjections;
    });
  }

  Widget _buildTable(String title, List<Map<String, dynamic>>? data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (data != null && data.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 20,
                  dataRowHeight: 60,
                  headingRowHeight: 40,
                  columns: [
                    ...data[0]
                        .keys
                        .where((key) => key != 'id')
                        .map((key) => DataColumn(label: Text(key))),
                  ],
                  rows: data
                      .map(
                        (row) => DataRow(
                          cells: [
                            ...row.entries
                                .where((entry) => entry.key != 'id')
                                .map(
                                  (entry) => DataCell(
                                    Text(
                                      entry.value.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          if (data == null || data.isEmpty)
            const Text('Aucune donnée disponible.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historique Bolus',
          style: TextStyle(
            fontSize: 20,
            color: AppConstants.violet.withOpacity(0.8),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppConstants.violet.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5.0),
              _buildTable(
                'Historique des injections',
                _historiqueInjectionsData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
