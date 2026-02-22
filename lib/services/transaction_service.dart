import 'package:pocket_vault/data/database_helper.dart';
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
    final List<Transaction> transactions = [];

    for (var map in result) {
      final tagMaps = await _repoTransactionTags.findTagsByTransactionId(
        map['id'],
      );
      final tags = tagMaps.map((t) => Tag.fromMap(t)).toList();

      transactions.add(Transaction.fromMap(map, tagsFromDb: tags));
    }

    return transactions;
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
    int? categoryId,
    DateTime? start,
    DateTime? end,
  }) async {
    final List<Map<String, dynamic>> result;

    if (categoryId != null) {
      result = await _repo.findByCategory(categoryId);
    } else if (start != null && end != null) {
      result = await _repo.findByDateRange(
        start.toIso8601String(),
        end.toIso8601String(),
      );
    } else {
      result = await _repo.findAll();
    }

    final List<Transaction> transactions = [];

    for (var map in result) {
      final tagMaps = await _repoTransactionTags.findTagsByTransactionId(
        map['id'],
      );

      final tags = tagMaps.map((t) => Tag.fromMap(t)).toList();
      transactions.add(Transaction.fromMap(map, tagsFromDb: tags));
    }

    return transactions;
  }
}
