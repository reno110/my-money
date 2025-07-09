import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpenses => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalBalance => totalIncome - totalExpenses;

  Future<void> loadTransactions() async {
    _transactions = await TransactionService.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await TransactionService.insertTransaction(tx);
    await loadTransactions(); // Refresh data
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await TransactionService.updateTransaction(tx);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await TransactionService.deleteTransaction(id);
    await loadTransactions();
  }
}
