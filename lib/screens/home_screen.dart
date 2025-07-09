import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_tile.dart';
import 'add_expense_screen.dart';
import '../widgets/balance_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    int dayOfYear(DateTime date) {
      return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    }

    // Group transactions by date (daily)
    Map<String, Map<String, double>> dailyMap = {};
    for (var tx in transactions) {
      final dateStr = DateFormat('dd/MM').format(tx.date);
      if (!dailyMap.containsKey(dateStr)) {
        dailyMap[dateStr] = {'income': 0, 'expense': 0};
      }
      if (tx.isIncome) {
        dailyMap[dateStr]!['income'] =
            dailyMap[dateStr]!['income']! + tx.amount;
      } else {
        dailyMap[dateStr]!['expense'] =
            dailyMap[dateStr]!['expense']! + tx.amount;
      }
    }
    // Sort by date (descending)
    final sortedDailyKeys = dailyMap.keys.toList()
      ..sort((a, b) =>
          DateFormat('dd/MM').parse(a).compareTo(DateFormat('dd/MM').parse(b)));
    final dailyData = [
      for (var key in sortedDailyKeys)
        {
          'income': dailyMap[key]!['income']!,
          'expense': dailyMap[key]!['expense']!
        }
    ];
    final dailyLabels = sortedDailyKeys;

    // Group transactions by week (weekly)
    Map<String, Map<String, double>> weeklyMap = {};
    Map<String, List<DateTime>> weeklyDates = {};
    for (var tx in transactions) {
      // Cari minggu ke berapa dalam tahun
      final weekYear =
          '${tx.date.year}-W${((dayOfYear(tx.date) - tx.date.weekday + 10) / 7).floor()}';
      if (!weeklyMap.containsKey(weekYear)) {
        weeklyMap[weekYear] = {'income': 0, 'expense': 0};
        weeklyDates[weekYear] = [];
      }
      weeklyDates[weekYear]!.add(tx.date);
      if (tx.isIncome) {
        weeklyMap[weekYear]!['income'] =
            weeklyMap[weekYear]!['income']! + tx.amount;
      } else {
        weeklyMap[weekYear]!['expense'] =
            weeklyMap[weekYear]!['expense']! + tx.amount;
      }
    }
    final sortedWeeklyKeys = weeklyMap.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    final weeklyData = [
      for (var key in sortedWeeklyKeys)
        {
          'income': weeklyMap[key]!['income']!,
          'expense': weeklyMap[key]!['expense']!
        }
    ];
    final weeklyLabels = [
      for (var key in sortedWeeklyKeys)
        () {
          final dates = weeklyDates[key]!;
          dates.sort((a, b) => a.compareTo(b));
          final start = dates.first;
          final end = dates.last;
          return '${DateFormat('dd/MM').format(start)}-${DateFormat('dd/MM').format(end)}';
        }()
    ];

    // Group transactions by month (monthly)
    Map<String, Map<String, double>> monthlyMap = {};
    for (var tx in transactions) {
      final monthYear = DateFormat('MM/yyyy').format(tx.date);
      if (!monthlyMap.containsKey(monthYear)) {
        monthlyMap[monthYear] = {'income': 0, 'expense': 0};
      }
      if (tx.isIncome) {
        monthlyMap[monthYear]!['income'] =
            monthlyMap[monthYear]!['income']! + tx.amount;
      } else {
        monthlyMap[monthYear]!['expense'] =
            monthlyMap[monthYear]!['expense']! + tx.amount;
      }
    }
    final sortedMonthlyKeys = monthlyMap.keys.toList()
      ..sort((a, b) => DateFormat('MM/yyyy')
          .parse(a)
          .compareTo(DateFormat('MM/yyyy').parse(b)));
    final monthlyData = [
      for (var key in sortedMonthlyKeys)
        {
          'income': monthlyMap[key]!['income']!,
          'expense': monthlyMap[key]!['expense']!
        }
    ];
    final monthlyLabels = [
      for (var key in sortedMonthlyKeys)
        DateFormat('MMM yyyy').format(DateFormat('MM/yyyy').parse(key))
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Money')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 6,
            color: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                      'Rp${transactionProvider.totalBalance.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        const Text('Income',
                            style: TextStyle(color: Colors.blue)),
                        Text(
                            'Rp${transactionProvider.totalIncome.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.green))
                      ]),
                      Column(children: [
                        const Text('Expenses',
                            style: TextStyle(color: Colors.blue)),
                        Text(
                            'Rp${transactionProvider.totalExpenses.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.red))
                      ]),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BalanceChart(
              dailyData: dailyData,
              weeklyData: weeklyData,
              monthlyData: monthlyData,
              dailyLabels: dailyLabels,
              weeklyLabels: weeklyLabels,
              monthlyLabels: monthlyLabels,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, index) {
                return TransactionTile(transaction: transactions[index]);
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
