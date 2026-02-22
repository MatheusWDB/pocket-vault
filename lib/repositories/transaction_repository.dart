import 'package:pocket_vault/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTransaction;
  static final columnId = DatabaseHelper.columnTransactionId;

  TransactionRepository(this._dbHelper);

  Future<int> insert(
    Map<String, dynamic> row, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    final db = await _dbHelper.database;

    return await db.query(table);
  }

  Future<Map<String, dynamic>?> findById(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> findByDateRange(
    String start,
    String end,
  ) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      table,
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> findByCategory(
    int categoryId, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    final result = await db.query(
      table,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    return result;
  }

  Future<int> update(
    Map<String, dynamic> row, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;

    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
