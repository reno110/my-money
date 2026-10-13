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
  final List<String> _periods = ['Harian', 'Mingguan', 'Bulanan'];

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Period Selector (iOS-style segmented control) ──
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(_periods.length, (index) {
                final isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1))
                              ]
                            : null,
                      ),
                      child: Text(
                        _periods[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF6750A4)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // ── Legend ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(const Color(0xFF4CAF50), 'Pemasukan'),
              const SizedBox(width: 20),
              _legendDot(const Color(0xFFEF5350), 'Pengeluaran'),
            ],
          ),
          const SizedBox(height: 12),

          // ── Chart ──
          SizedBox(
            height: 140,
            child: currentData.isEmpty
                ? Center(
                    child: Text('Belum ada data',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 13)),
                  )
                : BarChart(
                    BarChartData(
                      barGroups:
                          List.generate(currentData.length, (i) {
                        final income = currentData[i]['income'] ?? 0;
                        final expense = currentData[i]['expense'] ?? 0;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: income,
                              color: const Color(0xFF4CAF50),
                              width: 10,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                            BarChartRodData(
                              toY: expense,
                              color: const Color(0xFFEF5350),
                              width: 10,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx >= 0 && idx < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(labels[idx],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600])),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
