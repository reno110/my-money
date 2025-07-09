import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceChart extends StatefulWidget {
  final List<Map<String, double>> dailyData;
  final List<Map<String, double>> weeklyData;
  final List<Map<String, double>> monthlyData;
  final List<String>? dailyLabels;
  final List<String>? weeklyLabels;
  final List<String>? monthlyLabels;

  const BalanceChart({
    super.key,
    required this.dailyData,
    required this.weeklyData,
    required this.monthlyData,
    this.dailyLabels,
    this.weeklyLabels,
    this.monthlyLabels,
  });

  @override
  State<BalanceChart> createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart> {
  int _selectedIndex = 0;

  List<Map<String, double>> get currentData {
    switch (_selectedIndex) {
      case 0:
        return widget.dailyData;
      case 1:
        return widget.weeklyData;
      case 2:
        return widget.monthlyData;
      default:
        return widget.dailyData;
    }
  }

  List<String> get labels {
    switch (_selectedIndex) {
      case 0:
        return widget.dailyLabels ??
            List.generate(widget.dailyData.length, (i) => 'D${i + 1}');
      case 1:
        return widget.weeklyLabels ??
            List.generate(widget.weeklyData.length, (i) => 'W${i + 1}');
      case 2:
        return widget.monthlyLabels ??
            List.generate(widget.monthlyData.length, (i) => 'M${i + 1}');
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Harian'),
              selected: _selectedIndex == 0,
              onSelected: (_) => setState(() => _selectedIndex = 0),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Mingguan'),
              selected: _selectedIndex == 1,
              onSelected: (_) => setState(() => _selectedIndex = 1),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Bulanan'),
              selected: _selectedIndex == 2,
              onSelected: (_) => setState(() => _selectedIndex = 2),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 125,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(currentData.length, (i) {
                final income = currentData[i]['income'] ?? 0;
                final expense = currentData[i]['expense'] ?? 0;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: income,
                      color: Colors.green,
                      width: 8,
                    ),
                    BarChartRodData(
                      toY: expense,
                      color: Colors.red,
                      width: 8,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx >= 0 && idx < labels.length) {
                        return Text(labels[idx]);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
