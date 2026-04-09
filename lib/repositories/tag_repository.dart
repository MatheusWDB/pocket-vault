import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TagRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTag;
  static final columnId = DatabaseHelper.columnTagId;
  static final columnName = DatabaseHelper.columnTagName;

  static const _entity = 'Tag';

  TagRepository(this._dbHelper);

  Future<int> insert(
    Map<String, dynamic> row, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      return await db.insert(table, row);
    } catch (_) {
      throw const RecordInsertException(_entity);
    }
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    try {
      final db = await _dbHelper.database;
      return await db.query(table);
    } catch (_) {
      throw const RecordQueryException(_entity);
    }
  }

  Future<Map<String, dynamic>> findById(int id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      if (result.isEmpty) throw const RecordNotFoundException(_entity);
      return result.first;
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordQueryException(_entity);
    }
  }

  Future<Map<String, dynamic>?> findByName(
    String name, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final result = await db.query(
        table,
        where: '$columnName = ?',
        whereArgs: [name],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (_) {
      throw const RecordQueryException(_entity);
    }
  }

  Future<void> update(Map<String, dynamic> row) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.update(
        table,
        row,
        where: '$columnId = ?',
        whereArgs: [row['id']],
      );
      if (count == 0) throw const RecordNotFoundException(_entity);
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordUpdateException(_entity);
    }
  }

  Future<void> delete(int id) async {
    try {
      final db = await _dbHelper.database;
      final count = await db.delete(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      if (count == 0) throw const RecordNotFoundException(_entity);
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordDeleteException(_entity);
    }
  }
}