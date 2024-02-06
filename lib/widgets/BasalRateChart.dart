import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BasalRateChart extends StatelessWidget {
  const BasalRateChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              'Profil Basal Actuel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5), // Espace sous le titre
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: buildLineChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLineChart() {
    final gridLine = FlLine(
      color: Color.fromARGB(255, 61, 69, 75),
      strokeWidth: 1,
    );

    final titlesTextStyle = TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingVerticalLine: (_) => gridLine,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (_) => gridLine,
          verticalInterval: 6,
          horizontalInterval: 0.1,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (_, __) => titlesTextStyle,
            margin: 10,
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '0h';
                case 6:
                  return '6h';
                case 12:
                  return '12h';
                case 18:
                  return '18h';
                case 24:
                  return '24h';
                default:
                  return ''; // Retourner une chaîne vide pour ne pas encombrer l'axe des x
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (_, __) => titlesTextStyle,
            getTitles: (value) {
              return '${value.toStringAsFixed(1)}U';
            },
            reservedSize: 28,
            margin: 10,
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 24,
        minY: 0,
        maxY: 1.5,
        lineBarsData: [
          LineChartBarData(
            spots: generateSpots(),
            isCurved: true,
            colors: [const Color.fromARGB(255, 0, 0, 0)],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> generateSpots() {
    // Simulation des données
    final simulatedData = <FlSpot>[
      FlSpot(0, 0.75),
      FlSpot(1, 0.7),
      FlSpot(2, 0.65),
      FlSpot(3, 0.65),
      FlSpot(4, 0.6),
      FlSpot(5, 0.7),
      FlSpot(6, 0.8),
      FlSpot(7, 0.85),
      FlSpot(8, 0.8),
      FlSpot(9, 0.75),
      FlSpot(10, 0.7),
      FlSpot(11, 0.65),
      FlSpot(12, 0.6),
      FlSpot(13, 0.55),
      FlSpot(14, 0.5),
      FlSpot(15, 0.45),
      FlSpot(16, 0.5),
      FlSpot(17, 0.55),
      FlSpot(18, 0.6),
      FlSpot(19, 0.65),
      FlSpot(20, 0.7),
      FlSpot(21, 0.75),
      FlSpot(22, 0.8),
      FlSpot(23, 0.85),
      FlSpot(24, 0.8),
    ];
    return simulatedData;
  }
}
