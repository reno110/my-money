class TransactionModel {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;

  TransactionModel({
    this.id,
    required this.category,
    required this.amount,
    required DateTime date,
    required this.isIncome,
  }) : date = DateTime(date.year, date.month, date.day);

  // Convert to Map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'isIncome': isIncome ? 1 : 0,
    };
  }

  // From DB Map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      isIncome: map['isIncome'] == 1,
    );
  }
}
