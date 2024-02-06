import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypod/utils/image_constant.dart';
import 'package:sqflite/sqflite.dart';

class ResumeGeneralCard extends StatefulWidget {
  final Database database;

  const ResumeGeneralCard({super.key, required this.database});

  @override
  _ResumeGeneralCardState createState() => _ResumeGeneralCardState();
}

class _ResumeGeneralCardState extends State<ResumeGeneralCard> {
  double currentBasalRate = 0.0;
  DateTime datechangementPod = DateTime.now();
  @override
  void initState() {
    super.initState();
    getLatestBolusAndBasalRate();
  }

  Future<void> getLatestBolusAndBasalRate() async {
    final List<Map<String, dynamic>> lastBolusList =
        await widget.database.query(
      'historique_injections_bolus',
      orderBy: 'date_injection DESC, heure_injection DESC',
      limit: 1,
    );

    setState(() {
      currentBasalRate = 0.75;
      datechangementPod = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, 'Basal en cours:', '$currentBasalRate u/h',
                  Icons.trending_down),
              _buildInfoRow(
                  context,
                  'Pod remplacé le:',
                  DateFormat('dd-MM-yyyy').format(datechangementPod),
                  Icons.event),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
