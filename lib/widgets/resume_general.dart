import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypod/utils/image_constant.dart';

class ResumeGeneralCard extends StatelessWidget {
  final double lastBolus;
  final DateTime lastBolusTime;
  final double currentBasalRate;
  final DateTime datechangementPod;

  const ResumeGeneralCard({
    Key? key,
    required this.lastBolus,
    required this.lastBolusTime,
    required this.currentBasalRate,
    required this.datechangementPod,
  }) : super(key: key);

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
              _buildInfoRow(
                  context, 'Dernier Bolus:', '$lastBolus units', Icons.bolt),
              _buildInfoRow(
                  context,
                  'Temps:',
                  '${DateFormat('HH:mm').format(lastBolusTime)}',
                  Icons.access_time),
              _buildInfoRow(context, 'Basal en cours:',
                  '$currentBasalRate units/hour', Icons.trending_down),
              _buildInfoRow(
                  context,
                  'Pod remplacé le:',
                  '${DateFormat('yyyy-MM-dd').format(datechangementPod)}',
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
          SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.subtitle1),
          Spacer(),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
