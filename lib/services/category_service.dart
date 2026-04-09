import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/category_exception.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/repositories/category_repository.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class CategoryService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = CategoryRepository(DatabaseHelper.instance);
  final _repoTransaction = TransactionRepository(DatabaseHelper.instance);

  Future<List<Category>> getAllCategories() async {
    final result = await _repo.findAll();
    return result.map((c) => Category.fromMap(c)).toList();
  }

  Future<Category> getCategoryById(int id) async {
    final result = await _repo.findById(id);
    return Category.fromMap(result);
  }

  Future<Category?> getCategoryByName(String name) async {
    final result = await _repo.findByName(name);
    if (result == null) return null;
    return Category.fromMap(result);
  }

  Future<Category> ensureCategoryExists(
    Category category, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;
    final result = await _repo.findByName(category.name, executor: db);

    if (result == null) {
      final newCategory = Category(name: category.name, color: category.color);
      final id = await _repo.insert(newCategory.toMap(), executor: db);
      return newCategory.copyWith(id: id);
    }

    return Category.fromMap(result);
  }

  Future<void> saveCategory(Category category) async {
    try {
      final categoryMap = category.toMap();
      
      category.id == null
          ? await _repo.insert(categoryMap)
          : await _repo.update(categoryMap);
    } on DatabaseException catch (e) {
      throw CategorySaveException(e.message);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final db = await _dbHelper.database;

      await db.transaction((txn) async {
        final result = await _repoTransaction.findWithFilters(
          [],
          [id],
          [],
          null,
          null,
          executor: txn,
        );

        if (result.isNotEmpty) throw const CategoryDeleteException();

        await _repo.delete(id, executor: txn);
      });
    } on CategoryException {
      rethrow;
    } on DatabaseException catch (e) {
      throw CategorySaveException(e.message);
    }
  }
}
