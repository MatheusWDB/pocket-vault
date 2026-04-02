import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/mock/mock_transaction.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:pocket_vault/services/tag_service.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class TransactionService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = TransactionRepository(DatabaseHelper.instance);
  final _categoryService = CategoryService();
  final _tagService = TagService();

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

      if (transaction.tags.isNotEmpty) {
        await _tagService.linkTagsToTransaction(
          transactionId,
          transaction.tags,
          executor: txn,
        );
      }

      if (transaction.isRecurring) {
        await processRecurringTransactions(executor: txn);
      }

      if (transaction.totalInstallments! > 1) {
        await processInstallmentsTransactions(transactionId, executor: txn);
      }
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      final category = await _categoryService.ensureCategoryExists(
        transaction.category,
        executor: txn,
      );

      await _repo.update(
        transaction.copyWith(category: category).toMap(),
        executor: txn,
      );

      if (transaction.tags.isNotEmpty) {
        await _tagService.linkTagsToTransaction(
          transaction.id!,
          transaction.tags,
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

  Future<void> processRecurringTransactions({
    sqflite.DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    final pendingMaps = await _repo.findPending(executor: db);
    if (pendingMaps.isEmpty) return;

    final pendingTransactions = _mapRowsToTransactions(pendingMaps);

    (executor == null)
        ? await (db as sqflite.Database).transaction((txn) async {
            await _runRecurringLogic(txn, pendingTransactions);
          })
        : await _runRecurringLogic(executor, pendingTransactions);
  }

  Future<void> _runRecurringLogic(
    sqflite.DatabaseExecutor txn,
    List<Transaction> pending,
  ) async {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    for (var template in pending) {
      final transactionDate = template.date;
      final int monthsDiff =
          ((now.year - transactionDate.year) * 12) +
          now.month -
          transactionDate.month;

      for (int i = 0; i <= monthsDiff; i++) {
        final instanceDate = transactionDate.addMonths(i);

        final newInstance = template.copyWith(
          id: Nullable(null),
          date: instanceDate,
          isRecurring: false,
          isTemplate: false,
          templateId: template.id!,
          lastGeneratedMonth: const Nullable(null),
          createdAt: now,
          updatedAt: const Nullable(null),
        );

        final newId = await _repo.insert(newInstance.toMap(), executor: txn);

        if (template.tags.isNotEmpty) {
          await _tagService.linkTagsToTransaction(
            newId,
            template.tags,
            executor: txn,
          );
        }

        final updatedTemplate = template.copyWith(
          lastGeneratedMonth: Nullable(currentMonth),
        );
        await _repo.update(updatedTemplate.toMap(), executor: txn);
      }
    }
  }

  Future<void> processInstallmentsTransactions(
    int templateId, {
    sqflite.DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;
    final result = await _repo.findById(templateId, executor: db);
    final template = _mapRowsToTransactions(result).first;

    (executor == null)
        ? await (db as sqflite.Database).transaction((txn) async {
            await _runInstallmentLogic(txn, template);
          })
        : await _runInstallmentLogic(executor, template);
  }

  Future<void> _runInstallmentLogic(
    sqflite.DatabaseExecutor txn,
    Transaction template,
  ) async {
    final now = DateTime.now();
    final date = template.date;

    for (int i = 0; i < template.totalInstallments!; i++) {
      final installmentDate = date.addMonths(i);

      final newInstallment = template.copyWith(
        id: const Nullable(null),
        date: installmentDate,
        currentInstallment: i + 1,
        templateId: template.id!,
        isTemplate: false,
        isRecurring: false,
        lastGeneratedMonth: const Nullable(null),
        createdAt: now,
        updatedAt: const Nullable(null),
      );

      final newId = await _repo.insert(newInstallment.toMap(), executor: txn);

      if (template.tags.isNotEmpty) {
        await _tagService.linkTagsToTransaction(
          newId,
          newInstallment.tags,
          executor: txn,
        );
      }
    }
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
          'isTemplate': row['isTemplate'],
          'templateId': row['templateId'],
          'totalInstallments': row['totalInstallments'],
          'currentInstallment': row['currentInstallment'],
          'lastGeneratedMonth': row['lastGeneratedMonth'],
          'createdAt': row['createdAt'],
          'updatedAt': row['updatedAt'],
          'category': {
            'id': row['categoryId'],
            'name': row['category_name'],
            'budgetLimit': row['category_budgetLimit'],
            'createdAt': row['category_created_at'],
          },
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

  Future<void> resetDatabase() async {
    final dbPath = await _dbHelper.database.then((db) => db.path);

    final db = await _dbHelper.database;
    await db.close();

    final file = File(dbPath);
    if (await file.exists()) {
      await file.delete();
      debugPrint('Banco de dados deletado com sucesso!');
    }
  }
}
