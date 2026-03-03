import 'package:pocket_vault/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TransactionTagsRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTransactionTags;
  static final tableTag = DatabaseHelper.tableTag;
  static final tableTransaction = DatabaseHelper.tableTransaction;

  static final columnRelTagId = DatabaseHelper.columnRelTagId;
  static final columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

  static final columnTagId = DatabaseHelper.columnTagId;
  static final columnTransactionId = DatabaseHelper.columnTransactionId;

  TransactionTagsRepository(this._dbHelper);

  Future<int> insert(
    int transactionId,
    int tagId, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    final row = {columnRelTransactionId: transactionId, columnRelTagId: tagId};

    return await db.insert(table, row);
  }

  Future<int> delete(int transactionId, int tagId) async {
    final db = await _dbHelper.database;

    return await db.delete(
      table,
      where: '$columnRelTransactionId = ? AND $columnRelTagId = ?',
      whereArgs: [transactionId, tagId],
    );
  }

  Future<int> deleteAllByTransaction(
    int transactionId, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    return await db.delete(
      table,
      where: '$columnRelTransactionId = ?',
      whereArgs: [transactionId],
    );
  }

  Future<List<Map<String, dynamic>>> findTagsByTransactionId(
    int transactionId, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    return await db.rawQuery(
      '''
        SELECT t.* FROM $tableTag t
        INNER JOIN $table tt ON t.$columnTagId = tt.$columnRelTagId
        WHERE tt.$columnRelTransactionId = ?
      ''',
      [transactionId],
    );
  }

  Future<List<Map<String, dynamic>>> findTransactionsByTagId(int tagId) async {
    final db = await _dbHelper.database;

    return await db.rawQuery(
      '''
        SELECT t.* FROM $tableTransaction t
        INNER JOIN $table tt ON t.$columnTransactionId = tt.$columnRelTransactionId
        WHERE tt.$columnRelTagId = ?
      ''',
      [tagId],
    );
  }
}
