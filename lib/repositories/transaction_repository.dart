import 'package:pocket_vault/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

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

  static final columnCatId = DatabaseHelper.columnCategoryId;
  static final columnCatName = DatabaseHelper.columnCategoryName;

  static final columnTagName = DatabaseHelper.columnTagName;
  static final columnTagId = DatabaseHelper.columnTagId;

  static final columnRelTagId = DatabaseHelper.columnRelTagId;
  static final columnRelTransactionId = DatabaseHelper.columnRelTransactionId;

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

    return await db.rawQuery(_sql(''));
  }

  Future<Map<String, dynamic>?> findById(int id) async {
    final db = await _dbHelper.database;

    final whereClause = '$columnId = ?';

    final result = await db.rawQuery(_sql(whereClause), [id]);

    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> findTitles() async {
    final db = await _dbHelper.database;

    return await db.query(
      table,
      distinct: true,
      columns: [columnTitle],
      orderBy: '$columnTitle ASC',
    );
  }

  Future<List<Map<String, dynamic>>> findWithFilters(
    List<String> titles,
    List<int> categoryIds,
    List<int> tagIds,
    String? start,
    String? end, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    if (titles.isEmpty &&
        categoryIds.isEmpty &&
        tagIds.isEmpty &&
        start == null &&
        end == null) {
      return await findAll();
    }

    final List<String> conditions = [];
    final List<dynamic> args = [];

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
        titleConditions.add('$columnTitle LIKE ?');

        args.add('%$title%');
      }

      conditions.add("(${titleConditions.join(' OR ')})");
    }

    if (categoryIds.isNotEmpty) {
      final String placeholders = List.filled(
        categoryIds.length,
        '?',
      ).join(', ');

      conditions.add('$columnCategoryId IN ($placeholders)');

      args.addAll(categoryIds);
    }

    if (start != null) {
      conditions.add('$columnDate >= ?');
      args.add(start);
    }

    if (end != null) {
      conditions.add('$columnDate <= ?');
      args.add(end);
    }

    final String whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final sql = _sql(whereClause);

    return await db.rawQuery(sql, args);
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

  String _sql(String whereClause) =>
      '''
        SELECT 
          t.*,
          c.$columnCatName as category_name,
          tg.$columnTagId as tag_id,
          tg.$columnTagName as tag_name
        FROM $table t
        INNER JOIN $tableC c ON t.$columnCategoryId = c.$columnCatId
        LEFT JOIN $tableTT tt ON t.$columnId = tt.$columnRelTransactionId
        LEFT JOIN $tableTg tg ON tt.$columnRelTagId = tg.$columnTagId
        $whereClause
        ORDER BY t.$columnDate DESC
      ''';
}
