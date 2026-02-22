import 'package:pocket_vault/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TransactionRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTransaction;
  static final columnId = DatabaseHelper.columnTransactionId;
  static final columnCategoryId = DatabaseHelper.columnTransactionCategoryId;
  static final columnDate = DatabaseHelper.columnTransactionDate;

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

  Future<List<Map<String, dynamic>>> findWithFilters(
    int? categoryId,
    String? start,
    String? end, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    String whereClause = '';
    final List<dynamic> whereArgs = [];

    if (categoryId != null) {
      whereClause += '$columnCategoryId = ?';
      whereArgs.add(categoryId);
    }

    if (start != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '$columnDate >= ?';
      whereArgs.add(start);
    }

    if (end != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += '$columnDate <= ?';
      whereArgs.add(end);
    }

    final result = await db.query(
      table,
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '$columnDate DESC',
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
