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
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  double _amount = 0;
  String _category = '';
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Makanan', 'icon': Icons.restaurant_rounded},
    {'name': 'Transportasi', 'icon': Icons.directions_car_rounded},
    {'name': 'Belanja', 'icon': Icons.shopping_bag_rounded},
    {'name': 'Hiburan', 'icon': Icons.movie_rounded},
    {'name': 'Tagihan', 'icon': Icons.receipt_long_rounded},
    {'name': 'Kesehatan', 'icon': Icons.local_hospital_rounded},
    {'name': 'Pendidikan', 'icon': Icons.school_rounded},
    {'name': 'Lainnya', 'icon': Icons.more_horiz_rounded},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Gaji', 'icon': Icons.account_balance_wallet_rounded},
    {'name': 'Freelance', 'icon': Icons.laptop_rounded},
    {'name': 'Investasi', 'icon': Icons.trending_up_rounded},
    {'name': 'Lainnya', 'icon': Icons.more_horiz_rounded},
  ];

  List<Map<String, dynamic>> get _currentCategories =>
      _isIncome ? _incomeCategories : _expenseCategories;

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
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Income / Expense Toggle ──
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isIncome
                                ? const Color(0xFF4CAF50)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward_rounded,
                                  size: 18,
                                  color: _isIncome
                                      ? Colors.white
                                      : Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                'Pemasukan',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _isIncome
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isIncome = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isIncome
                                ? const Color(0xFFEF5350)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_upward_rounded,
                                  size: 18,
                                  color: !_isIncome
                                      ? Colors.white
                                      : Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                'Pengeluaran',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: !_isIncome
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Amount Input ──
              Text('Jumlah',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                  hintText: '0',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF6750A4), width: 2),
                  ),
                ),
                onSaved: (val) => _amount = double.tryParse(val!) ?? 0,
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Masukkan jumlah' : null,
              ),
              const SizedBox(height: 24),

              // ── Date Picker ──
              Text('Tanggal',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: Colors.grey[600], size: 20),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Category Chips ──
              Text('Kategori',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[700])),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _currentCategories.map((cat) {
                  final isSelected = _category == cat['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _category = cat['name'];
                        _categoryController.text = cat['name'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6750A4)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6750A4)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat['icon'],
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            cat['name'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  hintText: 'Atau ketik kategori sendiri...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF6750A4), width: 2),
                  ),
                ),
                onSaved: (val) => _category = val!,
                onChanged: (val) => setState(() => _category = val),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Masukkan kategori' : null,
              ),
              const SizedBox(height: 32),

              // ── Save Button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
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
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Transaksi',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
