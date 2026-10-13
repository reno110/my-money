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
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    int dayOfYear(DateTime date) {
      return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    }

    // ── Group transactions by date (daily) ──
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

    // ── Group transactions by week (weekly) ──
    Map<String, Map<String, double>> weeklyMap = {};
    Map<String, List<DateTime>> weeklyDates = {};
    for (var tx in transactions) {
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

    // ── Group transactions by month (monthly) ──
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

    // ── UI ──
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Money',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy')
                              .format(DateTime.now()),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.person_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ),

            // ── Balance Card ──
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6750A4), Color(0xFF9A82DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6750A4).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Total Saldo',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        currencyFormat
                            .format(transactionProvider.totalBalance),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // Pemasukan
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.greenAccent.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                      Icons.arrow_downward_rounded,
                                      color: Colors.greenAccent,
                                      size: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Pemasukan',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11)),
                                      Text(
                                        currencyFormat.format(
                                            transactionProvider.totalIncome),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Pengeluaran
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.redAccent.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Colors.redAccent,
                                      size: 16),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Pengeluaran',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11)),
                                      Text(
                                        currencyFormat.format(
                                            transactionProvider
                                                .totalExpenses),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Chart ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BalanceChart(
                  dailyData: dailyData,
                  weeklyData: weeklyData,
                  monthlyData: monthlyData,
                  dailyLabels: dailyLabels,
                  weeklyLabels: weeklyLabels,
                  monthlyLabels: monthlyLabels,
                ),
              ),
            ),

            // ── Section Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaksi Terbaru',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${transactions.length} transaksi',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),

            // ── Transaction List ──
            if (transactions.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('Belum ada transaksi',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Tap + untuk menambah transaksi',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 13)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) =>
                        TransactionTile(transaction: transactions[index]),
                    childCount: transactions.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Transaksi'),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
