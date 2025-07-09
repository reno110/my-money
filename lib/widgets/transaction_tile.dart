import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        color: transaction.isIncome ? Colors.green : Colors.red,
      ),
      title: Text(transaction.category),
      subtitle: Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
      trailing: Text(
        'Rp${transaction.amount.toStringAsFixed(0)}',
        style: TextStyle(
          color: transaction.isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
