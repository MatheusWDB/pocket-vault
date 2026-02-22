import 'package:pocket_vault/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper;
  static final table = DatabaseHelper.tableCategory;
  static final columnId = DatabaseHelper.columnCategoryId;

  CategoryRepository(this._dbHelper);

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await _dbHelper.database;

    return db.insert(table, row);
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

  Future<int> update(Map<String, dynamic> row) async {
    final db = await _dbHelper.database;

    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [row['id']],
    );
  }

  Future<int> delete(int id, {DatabaseExecutor? executor}) async {
    final db = executor ?? await _dbHelper.database;

    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
