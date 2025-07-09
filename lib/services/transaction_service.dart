import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'transactions.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
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
    });
  }

  static Future<void> insertTransaction(TransactionModel tx) async {
    final dbClient = await db;
    await dbClient.insert('transactions', tx.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<TransactionModel>> getAllTransactions() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('transactions', orderBy: 'date DESC');

    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  static Future<void> updateTransaction(TransactionModel tx) async {
    final dbClient = await db;
    await dbClient.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  static Future<void> deleteTransaction(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
