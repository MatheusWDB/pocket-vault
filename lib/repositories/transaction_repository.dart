import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TransactionRepository {
  final DatabaseHelper _dbHelper;

  TransactionRepository(this._dbHelper);

  static const table = DatabaseHelper.tableTransaction;
  static const tableCategory = DatabaseHelper.tableCategory;
  static const tableTag = DatabaseHelper.tableTag;
  static const tableTransactionTags = DatabaseHelper.tableTransactionTags;

  static const columnTransactionId = DatabaseHelper.columnTransactionId;
  static const columnTransactionTitle = DatabaseHelper.columnTransactionTitle;
  static const columnTransactionCategoryId =
      DatabaseHelper.columnTransactionCategoryId;
  static const columnTransactionDate = DatabaseHelper.columnTransactionDate;
  static const columnTransactionIsRecurring =
      DatabaseHelper.columnTransactionIsRecurring;
  static const columnTransactionIsTemplate =
      DatabaseHelper.columnTransactionIsTemplate;
  static const columnTransactionLastGeneratedMonth =
      DatabaseHelper.columnTransactionLastGeneratedMonth;

  static const columnCategoryId = DatabaseHelper.columnCategoryId;
  static const columnCategoryName = DatabaseHelper.columnCategoryName;
  static const columnCategoryBudgetLimit =
      DatabaseHelper.columnCategoryBudgetLimit;
  static const columnCategoryColor = DatabaseHelper.columnCategoryColor;
  static const columnCategoryCreatedAt = DatabaseHelper.columnCategoryCreatedAt;

  static const columnTagName = DatabaseHelper.columnTagName;
  static const columnTagId = DatabaseHelper.columnTagId;

  static const columnRelTagId = DatabaseHelper.columnRelTagId;
  static const columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

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
      return await db.rawQuery(
        _sql('WHERE t.$columnTransactionIsTemplate = 0'),
      );
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
      final result = await db.rawQuery(
        _sql('WHERE t.$columnTransactionId = ?'),
        [id],
      );
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
        columns: [columnTransactionTitle],
        orderBy: '$columnTransactionTitle ASC',
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

      final List<String> conditions = ['t.$columnTransactionIsTemplate = ?'];
      final List<Object?> args = [0];

      if (tagIds.isNotEmpty) {
        final String placeholders = List.filled(tagIds.length, '?').join(', ');

        conditions.add('''
          EXISTS (
            SELECT 1 FROM $tableTransactionTags tt 
            WHERE tt.$columnRelTransactionId = t.$columnTransactionId 
            AND tt.$columnRelTagId IN ($placeholders)
          )
      ''');

        args.addAll(tagIds);
      }

      if (titles.isNotEmpty) {
        final List<String> titleConditions = [];

        for (var title in titles) {
          titleConditions.add('t.$columnTransactionTitle LIKE ?');

          args.add('%$title%');
        }

        conditions.add("(${titleConditions.join(' OR ')})");
      }

      if (categoryIds.isNotEmpty) {
        final String placeholders = List.filled(
          categoryIds.length,
          '?',
        ).join(', ');

        conditions.add('t.$columnTransactionCategoryId IN ($placeholders)');

        args.addAll(categoryIds);
      }

      if (start != null) {
        conditions.add('t.$columnTransactionDate >= ?');
        args.add(start);
      }

      if (end != null) {
        conditions.add('t.$columnTransactionDate <= ?');
        args.add(end);
      }

      final String whereClause = 'WHERE ${conditions.join(' AND ')}';

      final sql = _sql(whereClause);

      return await db.rawQuery(sql, args);
    } catch (e) {
      throw const RecordQueryException();
    }
  }

  Future<int?> findMinYear({DatabaseExecutor? executor}) async {
    final db = executor ?? await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT MIN(strftime(\'%Y\', $columnTransactionDate)) as min_year FROM $table WHERE $columnTransactionIsTemplate = 0',
    );
    final raw = result.first['min_year'];
    return raw != null ? int.tryParse(raw as String) : null;
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
        where: '$columnTransactionId = ?',
        whereArgs: [row['id']],
      );
      if (count == 0) throw const RecordNotFoundException();
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordUpdateException();
    }
  }

  Future<void> delete(int id, {DatabaseExecutor? executor}) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final count = await db.delete(
        table,
        where: '$columnTransactionId = ?',
        whereArgs: [id],
      );
      if (count == 0) throw const RecordNotFoundException();
    } on DatabaseException {
      rethrow;
    } catch (_) {
      throw const RecordDeleteException();
    }
  }

  Future<List<Map<String, dynamic>>> findByTemplateId(
    int templateId, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      return await db.rawQuery(
        '''
        SELECT $_selectColumns
        $_fromAndJoins
        WHERE t.templateId = ? AND t.$columnTransactionIsTemplate = 0
        ORDER BY t.$columnTransactionDate ASC
        ''',
        [templateId],
      );
    } catch (_) {
      throw const RecordQueryException();
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
          'WHERE t.$columnTransactionIsRecurring = 1 AND t.$columnTransactionIsTemplate = 1 '
          'AND (t.$columnTransactionLastGeneratedMonth IS NULL '
          'OR t.$columnTransactionLastGeneratedMonth != ?)';
      return await db.rawQuery(_sql(whereClause), [currentMonth]);
    } catch (_) {
      throw const RecordQueryException();
    }
  }

  static final _selectColumns =
      '''
        t.*,
        c.$columnCategoryName as category_name,
        c.$columnCategoryBudgetLimit as category_budgetLimit,
        c.$columnCategoryColor as category_color,
        c.$columnCategoryCreatedAt as category_created_at,
        tg.$columnTagId as tag_id,
        tg.$columnTagName as tag_name
      ''';

  static final _fromAndJoins =
      '''
        FROM $table t
        INNER JOIN $tableCategory c
          ON t.$columnTransactionCategoryId = c.$columnCategoryId
        LEFT JOIN $tableTransactionTags tt
          ON t.$columnTransactionId = tt.$columnRelTransactionId
        LEFT JOIN $tableTag tg
          ON tt.$columnRelTagId = tg.$columnTagId
      ''';

  String _sql(String whereClause) {
    final finalWhere =
        (whereClause.isNotEmpty &&
            !whereClause.trim().toUpperCase().startsWith('WHERE'))
        ? 'WHERE $whereClause'
        : whereClause;

    return '''
            SELECT $_selectColumns
            $_fromAndJoins
            $finalWhere
            ORDER BY t.$columnTransactionDate DESC
          ''';
  }
}
