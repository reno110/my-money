import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class TransactionDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'my_money.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            note TEXT,
            amount REAL,
            date TEXT,
            isIncome INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', {
      'category': transaction.category,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
      'isIncome': transaction.isIncome ? 1 : 0,
    });
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        category: maps[i]['category'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
        isIncome: maps[i]['isIncome'] == 1,
      );
    });
  }

  Future<int> updateTransaction(int id, TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      {
        'category': transaction.category,
        'amount': transaction.amount,
        'date': transaction.date.toIso8601String(),
        'isIncome': transaction.isIncome ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
