import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TransactionRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableTransaction;
  static final tableC = DatabaseHelper.tableCategory;
  static final tableTg = DatabaseHelper.tableTag;
  static final tableTT = DatabaseHelper.tableTransactionTags;

  static final columnId = DatabaseHelper.columnTransactionId;
  static final columnTitle = DatabaseHelper.columnTransactionTitle;
  static final columnCategoryId = DatabaseHelper.columnTransactionCategoryId;
  static final columnDate = DatabaseHelper.columnTransactionDate;
  static final columnIsRecurring = DatabaseHelper.columnTransactionIsRecurring;
  static final columnIsTemplate = DatabaseHelper.columnTransactionIsTemplate;
  static final columnLastGeneratedMonth =
      DatabaseHelper.columnTransactionLastGeneratedMonth;

  static final columnCatId = DatabaseHelper.columnCategoryId;
  static final columnCatName = DatabaseHelper.columnCategoryName;
  static final columnCatBudgetLimit = DatabaseHelper.columnCategoryBudgetLimit;
  static final columnCatColor = DatabaseHelper.columnCategoryColor;
  static final columnCatCreatedAt = DatabaseHelper.columnCategoryCreatedAt;

  static final columnTagName = DatabaseHelper.columnTagName;
  static final columnTagId = DatabaseHelper.columnTagId;

  static final columnRelTagId = DatabaseHelper.columnRelTagId;
  static final columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

  TransactionRepository(this._dbHelper);

  Future<int> insert(
    Map<String, dynamic> row, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      return await db.insert(table, row);
    } catch (_) {
      throw const RecordInsertException();
    }
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    try {
      final db = await _dbHelper.database;
      return await db.rawQuery(_sql('WHERE t.$columnIsTemplate = 0'));
    } catch (_) {
      throw const RecordQueryException();
    }
  }

  Future<List<Map<String, dynamic>>> findById(
    int id, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final result = await db.rawQuery(_sql('WHERE t.$columnId = ?'), [id]);
      if (result.isEmpty) throw const RecordNotFoundException();
      return result;
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordQueryException();
    }
  }

  Future<List<Map<String, dynamic>>> findTitles() async {
    try {
      final db = await _dbHelper.database;
      return await db.query(
        table,
        distinct: true,
        columns: [columnTitle],
        orderBy: '$columnTitle ASC',
      );
    } catch (_) {
      throw const RecordQueryException();
    }
  }

  Future<List<Map<String, dynamic>>> findWithFilters(
    List<String> titles,
    List<int> categoryIds,
    List<int> tagIds,
    String? start,
    String? end, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;

      if (titles.isEmpty &&
          categoryIds.isEmpty &&
          tagIds.isEmpty &&
          start == null &&
          end == null) {
        return await findAll();
      }

      final List<String> conditions = ['t.$columnIsTemplate = ?'];
      final List<Object?> args = [0];

      if (tagIds.isNotEmpty) {
        final String placeholders = List.filled(tagIds.length, '?').join(', ');

        conditions.add('''
          EXISTS (
            SELECT 1 FROM $tableTT tt 
            WHERE tt.$columnRelTransactionId = t.$columnId 
            AND tt.$columnRelTagId IN ($placeholders)
          )
      ''');

        args.addAll(tagIds);
      }

      if (titles.isNotEmpty) {
        final List<String> titleConditions = [];

        for (var title in titles) {
          titleConditions.add('t.$columnTitle LIKE ?');

          args.add('%$title%');
        }

        conditions.add("(${titleConditions.join(' OR ')})");
      }

      if (categoryIds.isNotEmpty) {
        final String placeholders = List.filled(
          categoryIds.length,
          '?',
        ).join(', ');

        conditions.add('t.$columnCategoryId IN ($placeholders)');

        args.addAll(categoryIds);
      }

      if (start != null) {
        conditions.add('t.$columnDate >= ?');
        args.add(start);
      }

      if (end != null) {
        conditions.add('t.$columnDate <= ?');
        args.add(end);
      }

      final String whereClause = 'WHERE ${conditions.join(' AND ')}';

      final sql = _sql(whereClause);

      return await db.rawQuery(sql, args);
    } catch (e) {
      throw const RecordQueryException();
    }
  }

  Future<void> update(
    Map<String, dynamic> row, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final count = await db.update(
        table,
        row,
        where: '$columnId = ?',
        whereArgs: [row['id']],
      );
      if (count == 0) throw const RecordNotFoundException();
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordUpdateException();
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
      if (count == 0) throw const RecordNotFoundException();
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordDeleteException();
    }
  }

  Future<List<Map<String, dynamic>>> findPending({
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final now = DateTime.now();
      final currentMonth =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final whereClause =
          'WHERE t.$columnIsRecurring = 1 AND t.$columnIsTemplate = 1 '
          'AND (t.$columnLastGeneratedMonth IS NULL '
          'OR t.$columnLastGeneratedMonth != ?)';
      return await db.rawQuery(_sql(whereClause), [currentMonth]);
    } catch (_) {
      throw const RecordQueryException();
    }
  }

  String _sql(String whereClause) {
    final finalWhere =
        (whereClause.isNotEmpty &&
            !whereClause.trim().toUpperCase().startsWith('WHERE'))
        ? 'WHERE $whereClause'
        : whereClause;

    return '''
        SELECT
          t.*,
          c.$columnCatName as category_name,
          c.$columnCatBudgetLimit as category_budgetLimit,
          c.$columnCatColor as category_color,
          c.$columnCatCreatedAt as category_created_at,
          tg.$columnTagId as tag_id,
          tg.$columnTagName as tag_name
        FROM $table t
        INNER JOIN $tableC c ON t.$columnCategoryId = c.$columnCatId
        LEFT JOIN $tableTT tt ON t.$columnId = tt.$columnRelTransactionId
        LEFT JOIN $tableTg tg ON tt.$columnRelTagId = tg.$columnTagId
        $finalWhere
        ORDER BY t.$columnDate DESC
      ''';
  }
}
