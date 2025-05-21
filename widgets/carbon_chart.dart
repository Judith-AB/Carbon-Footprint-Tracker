// lib/widgets/carbon_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CarbonChart extends StatelessWidget {
  const CarbonChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from API
    final weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final carbonData = [3000, 4500, 2000, 6000, 2500, 1500, 1000];

    // Find max value for scaling
    final maxEmission = carbonData.reduce((max, value) => max > value ? max : value);

    // Calculate total emissions
    final totalEmissions = carbonData.reduce((a, b) => a + b) / 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "This Week's Emissions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxEmission * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            weekdayLabels[value.toInt() % weekdayLabels.length],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: carbonData[index].toDouble(),
                        color: index == 6
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.secondary,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Lower is better",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                "Total: ${totalEmissions.toStringAsFixed(1)}kg CO₂",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}