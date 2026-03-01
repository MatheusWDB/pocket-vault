import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/mock/mock_transaction.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/repositories/tag_repository.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:pocket_vault/repositories/transaction_tags_repository.dart';

class TransactionService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = TransactionRepository(DatabaseHelper.instance);
  final _repoTag = TagRepository(DatabaseHelper.instance);
  final _repoTransactionTags = TransactionTagsRepository(
    DatabaseHelper.instance,
  );

  Future<List<Transaction>> getAllTransactions() async {
    final result = await _repo.findAll();

    return _mapTagToTransactions(result);
  }

  Future<Transaction?> getTransactionById(int id) async {
    final result = await _repo.findById(id);

    if (result == null || result.isEmpty) return null;

    final tags = await _repoTransactionTags.findTagsByTransactionId(
      result['id'],
    );

    return Transaction.fromMap(
      result,
      tagsFromDb: tags.map((t) => Tag.fromMap(t)).toList(),
    );
  }

  Future<void> createTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      final transactionId = await _repo.insert(
        transaction.toMap(),
        executor: txn,
      );

      for (Tag tag in transaction.tags) {
        final existingTag = await _repoTag.findByName(tag.name, executor: txn);

        final int tagId = (existingTag == null)
            ? await _repoTag.insert(tag.toMap(), executor: txn)
            : existingTag['id'];

        await _repoTransactionTags.insert(transactionId, tagId, executor: txn);
      }
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;

    db.transaction((txn) async {
      await _repo.update(transaction.toMap(), executor: txn);

      await _repoTransactionTags.deleteAllByTransaction(
        transaction.id!,
        executor: txn,
      );

      for (Tag tag in transaction.tags) {
        final existingTag = await _repoTag.findByName(tag.name, executor: txn);

        final int tagId = (existingTag == null)
            ? await _repoTag.insert(tag.toMap(), executor: txn)
            : existingTag['id'];

        await _repoTransactionTags.insert(
          transaction.id!,
          tagId,
          executor: txn,
        );
      }
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
    final List<Transaction> list = result
        .map((t) => Transaction.fromMap(t))
        .toList();
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

    return _mapTagToTransactions(result);
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

  List<Transaction> _mapTagToTransactions(List<Map<String, dynamic>> result) {
    final Map<int, Transaction> transactionMap = {};

    for (var row in result) {
      final id = row['id'] as int;

      if (!transactionMap.containsKey(id)) {
        transactionMap[id] = Transaction.fromMap(row);
      }

      if (row['tag_id'] != null) {
        transactionMap[id]!.tags.add(
          Tag(id: row['tag_id'], name: row['tag_name']),
        );
      }
    }

    return transactionMap.values.toList();
  }
}
