import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TransactionTagsRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTransactionTags;
  static final tableTag = DatabaseHelper.tableTag;
  static final tableTransaction = DatabaseHelper.tableTransaction;

  static final columnRelTagId = DatabaseHelper.columnRelTagId;
  static final columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

  static final columnTagId = DatabaseHelper.columnTagId;
  static final columnTransactionId = DatabaseHelper.columnTransactionId;

  static const _entity = 'Vínculo transação-tag';

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
      throw const RecordInsertException(_entity);
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
      if (count == 0) throw const RecordNotFoundException(_entity);
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordDeleteException(_entity);
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
      throw const RecordDeleteException(_entity);
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
      throw const RecordQueryException(_entity);
    }
  }

  Future<List<Map<String, dynamic>>> findTransactionsByTagId(int tagId) async {
    try {
      final db = await _dbHelper.database;
      return await db.rawQuery(
        '''
        SELECT t.* FROM $tableTransaction t
        INNER JOIN $table tt ON t.$columnTransactionId = tt.$columnRelTransactionId
        WHERE tt.$columnRelTagId = ?
      ''',
        [tagId],
      );
    } catch (_) {
      throw const RecordQueryException(_entity);
    }
  }
}
