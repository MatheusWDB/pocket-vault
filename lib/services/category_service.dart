import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/mock/mock_category.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/repositories/category_repository.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:sqflite/sqflite.dart';

class CategoryService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = CategoryRepository(DatabaseHelper.instance);
  final _repoTransaction = TransactionRepository(DatabaseHelper.instance);

  Future<List<Category>> getAllCategories() async {
    final result = await _repo.findAll();

    // ---------------Remover Mock---------------
    if (result.isEmpty) {
      return mockCategories;
    }
    // ------------------------------------------

    return result.map((c) => Category.fromMap(c)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final result = await _repo.findById(id);

    if (result == null || result.isEmpty) return null;

    return Category.fromMap(result);
  }

  Future<Category?> getCategoryByName(String name) async {
    final result = await _repo.findByName(name);

    if (result == null || result.isEmpty) return null;

    return Category.fromMap(result);
  }

  Future<Category> ensureCategoryExists(
    Category catgory, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    final result = await _repo.findByName(catgory.name, executor: db);

    if (result == null || result.isEmpty) {
      final category = Category(name: catgory.name);
      return category.copyWith(
        id: await _repo.insert(category.toMap(), executor: db),
      );
    }

    return Category.fromMap(result);
  }

  Future<void> saveCategory(Category category) async {
    category.id == null
        ? await _repo.insert(category.toMap())
        : await _repo.update(category.toMap());
  }

  Future<void> deleteCategory(int id) async {
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

      if (result.isNotEmpty) return;

      await _repo.delete(id, executor: txn);
    });
  }
}
