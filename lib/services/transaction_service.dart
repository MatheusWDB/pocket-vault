import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/mock/mock_transaction.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:pocket_vault/repositories/transaction_tags_repository.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:pocket_vault/services/tag_service.dart';

class TransactionService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = TransactionRepository(DatabaseHelper.instance);
  final _categoryService = CategoryService();
  final _tagService = TagService();
  final _repoTransactionTags = TransactionTagsRepository(
    DatabaseHelper.instance,
  );

  Future<List<Transaction>> getAllTransactions() async {
    final result = await _repo.findAll();

    return _mapRowsToTransactions(result);
  }

  Future<Transaction?> getTransactionById(int id) async {
    final result = await _repo.findById(id);

    if (result.isEmpty) return null;

    final transactionMap = _mapRowsToTransactions(result);

    return transactionMap.first;
  }

  Future<void> createTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      final category = await _categoryService.ensureCategoryExists(
        transaction.category,
        executor: txn,
      );

      final transactionId = await _repo.insert(
        transaction.copyWith(category: category).toMap(),
        executor: txn,
      );

      await _tagService.linkTagsToTransaction(
        transactionId,
        transaction.tags,
        executor: txn,
      );
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await _repo.update(transaction.toMap(), executor: txn);

      await _repoTransactionTags.deleteAllByTransaction(
        transaction.id!,
        executor: txn,
      );

      await _tagService.linkTagsToTransaction(
        transaction.id!,
        transaction.tags,
        executor: txn,
      );
    });
  }

  Future<void> deleteTransaction(int id) async {
    await _repo.delete(id);
  }

  Future<List<Transaction>> getTransactionsByFilter({
    required List<String> titles,
    required List<int> categoryIds,
    required List<int> tagIds,
    DateTime? start,
    DateTime? end,
  }) async {
    final result = await _repo.findWithFilters(
      titles,
      categoryIds,
      tagIds,
      start?.toIso8601String(),
      end?.toIso8601String(),
    );

    // ---------------Remover Mock---------------
    final List<Transaction> list = _mapRowsToTransactions(result);

    if (list.isEmpty) {
      if (list.isEmpty) {
        return mockTransactions.where((t) {
          final matchTitle =
              titles.isEmpty || titles.any((title) => t.title.contains(title));
          final matchCategory =
              categoryIds.isEmpty || categoryIds.contains(t.category.id!);
          final matchTags =
              tagIds.isEmpty || t.tags.any((tag) => tagIds.contains(tag.id));
          final matchDate =
              (start == null || t.date.isAfter(start)) &&
              (end == null || t.date.isBefore(end));

          return matchTitle && matchCategory && matchTags && matchDate;
        }).toList()..sort((a, b) => b.date.compareTo(a.date));
      }
    }
    // -------------------------------------------

    return _mapRowsToTransactions(result);
  }

  Future<List<String>> getAllTitles() async {
    final maps = await _repo.findTitles();

    // ---------------Remover Mock---------------
    final List<String> titles = maps.map((m) => m['title'] as String).toList();
    if (titles.isEmpty) {
      return mockTransactions.map((t) => t.title).toList();
    }
    // -------------------------------------------

    return maps.map((m) => m['title'] as String).toList();
  }

  List<Transaction> _mapRowsToTransactions(List<Map<String, dynamic>> result) {
    final Map<int, Map<String, dynamic>> transactions = {};

    for (var row in result) {
      final transactionId = row['id'] as int;

      if (!transactions.containsKey(transactionId)) {
        transactions[transactionId] = {
          'id': transactionId,
          'title': row['title'],
          'amount': row['amount'],
          'date': row['date'],
          'description': row['description'],
          'isRecurring': row['isRecurring'],
          'createdAt': row['createdAt'],
          'updatedAt': row['updatedAt'],
          'category': {'id': row['categoryId'], 'name': row['category_name']},
          'tags': <Map<String, dynamic>>[],
        };
      }

      if (row['tag_id'] != null) {
        (transactions[transactionId]!['tags'] as List<Map<String, dynamic>>)
            .add({'id': row['tag_id'], 'name': row['tag_name']});
      }
    }

    return transactions.values.map(((t) => Transaction.fromMap(t))).toList();
  }
}
