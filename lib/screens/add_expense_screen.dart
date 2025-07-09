import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String _category = '';
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Text('Tanggal: ' +
                      DateFormat('dd MMM yyyy').format(_selectedDate)),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              onSaved: (val) => _amount = double.tryParse(val!) ?? 0,
              validator: (val) => val!.isEmpty ? 'Enter amount' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              onSaved: (val) => _category = val!,
              validator: (val) => val!.isEmpty ? 'Enter category' : null,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isIncome = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isIncome ? Colors.green : Colors.grey[200],
                      foregroundColor: _isIncome ? Colors.white : Colors.black,
                    ),
                    child: const Text('Income'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isIncome = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !_isIncome ? Colors.red : Colors.grey[200],
                      foregroundColor: !_isIncome ? Colors.white : Colors.black,
                    ),
                    child: const Text('Expenses'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final isValid = _formKey.currentState?.validate();
                if (isValid ?? false) {
                  _formKey.currentState?.save();
                  final newTransaction = TransactionModel(
                    amount: _amount,
                    category: _category,
                    isIncome: _isIncome,
                    date: _selectedDate,
                  );
                  Provider.of<TransactionProvider>(context, listen: false)
                      .addTransaction(newTransaction);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            )
          ]),
        ),
      ),
    );
  }
}
