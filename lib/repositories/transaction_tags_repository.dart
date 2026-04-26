import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TransactionTagsRepository {
  final DatabaseHelper _dbHelper;
  static const table = DatabaseHelper.tableTransactionTags;
  static const tableTag = DatabaseHelper.tableTag;
  static const tableTransaction = DatabaseHelper.tableTransaction;

  static const columnRelTagId = DatabaseHelper.columnRelTagId;
  static const columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

  static const columnTagId = DatabaseHelper.columnTagId;
  static const columnTransactionId = DatabaseHelper.columnTransactionId;

  TransactionTagsRepository(this._dbHelper);

  Future<void> insert(
    int transactionId,
    int tagId, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      await db.insert(table, {
        columnRelTransactionId: transactionId,
        columnRelTagId: tagId,
      });
    } catch (_) {
      throw const RecordInsertException();
    }
  }

  Future<void> delete(int transactionId, int tagId) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.delete(
        table,
        where: '$columnRelTransactionId = ? AND $columnRelTagId = ?',
        whereArgs: [transactionId, tagId],
      );
      if (count == 0) throw const RecordNotFoundException();
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordDeleteException();
    }
  }

  Future<void> deleteAllByTransaction(
    int transactionId, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      await db.delete(
        table,
        where: '$columnRelTransactionId = ?',
        whereArgs: [transactionId],
      );
    } catch (_) {
      throw const RecordDeleteException();
    }
  }

  Future<List<Map<String, dynamic>>> findTagsByTransactionId(
    int transactionId, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      return await db.rawQuery(
        '''
        SELECT t.* FROM $tableTag t
        INNER JOIN $table tt ON t.$columnTagId = tt.$columnRelTagId
        WHERE tt.$columnRelTransactionId = ?
      ''',
        [transactionId],
      );
    } catch (_) {
      throw const RecordQueryException();
    }
  }
}
