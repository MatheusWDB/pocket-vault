import 'dart:io';

import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:pocket_vault/exceptions/transaction_exception.dart';
import 'package:pocket_vault/models/nullable.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/repositories/transaction_repository.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:pocket_vault/services/tag_service.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/transaction_mapper.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class TransactionService {
  final DatabaseHelper _dbHelper;
  final TransactionRepository _repo;
  final CategoryService _categoryService;
  final TagService _tagService;

  TransactionService({
    DatabaseHelper? dbHelper,
    TransactionRepository? repo,
    CategoryService? categoryService,
    TagService? tagService,
  }) : _dbHelper = dbHelper ?? DatabaseHelper.instance,
       _repo =
           repo ?? TransactionRepository(dbHelper ?? DatabaseHelper.instance),
       _categoryService =
           categoryService ?? CategoryService(dbHelper: dbHelper),
       _tagService = tagService ?? TagService(dbHelper: dbHelper);

  // ─── Leitura ────────────────────────────────────────────────────────────────

  Future<List<Transaction>> getAllTransactions() async {
    final result = await _repo.findAll();
    return TransactionMapper.fromRows(result);
  }

  Future<Transaction> getTransactionById(int id) async {
    final result = await _repo.findById(id);
    return TransactionMapper.fromRows(result).first;
  }

  Future<List<Transaction>> getTransactionsByFilter({
    required List<String> titles,
    required List<int> categoryIds,
    required List<int> tagIds,
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      final result = await _repo.findWithFilters(
        titles,
        categoryIds,
        tagIds,
        start?.toIso8601String(),
        end?.toIso8601String(),
      );
      return TransactionMapper.fromRows(result);
    } on DatabaseException catch (_) {
      throw TransactionNotFoundException();
    }
  }

  Future<List<String>> getAllTitles() async {
    final maps = await _repo.findTitles();
    return maps.map((m) => m['title'] as String).toList();
  }

  Future<int?> getMinYear() async {
    return await _repo.findMinYear();
  }
  // ─── Criação ────────────────────────────────────────────────────────────────

  Future<void> createTransaction(Transaction transaction) async {
    try {
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
          final pendingMaps = await _repo.findPending(executor: txn);
          if (pendingMaps.isNotEmpty) {
            final pending = TransactionMapper.fromRows(pendingMaps);
            await _runRecurringLogic(txn, pending);
          }
        }

        if ((transaction.totalInstallments ?? 1) > 1) {
          final result = await _repo.findById(transactionId, executor: txn);
          final template = TransactionMapper.fromRows(result).first;
          await _runInstallmentLogic(txn, template);
        }
      });
    } on TransactionException {
      rethrow;
    } on DatabaseException catch (_) {
      throw TransactionSaveException();
    }
  }

  // ─── Edição ─────────────────────────────────────────────────────────────────

  Future<void> updateTransactionOnly(Transaction transaction) async {
    try {
      final db = await _dbHelper.database;
      await db.transaction((txn) async {
        final category = await _categoryService.ensureCategoryExists(
          transaction.category,
          executor: txn,
        );
        await _repo.update(
          transaction
              .copyWith(category: category, updatedAt: Nullable(DateTime.now()))
              .toMap(),
          executor: txn,
        );
        await _tagService.syncTagsForTransaction(
          transaction.id!,
          transaction.tags,
          executor: txn,
        );

        final templateId = transaction.templateId;
        final newTotal = transaction.totalInstallments;
        if (templateId != null &&
            newTotal != null &&
            !transaction.isRecurring) {
          final templateRows = await _repo.findById(templateId, executor: txn);
          final template = TransactionMapper.fromRows(templateRows).first;

          if (template.totalInstallments != newTotal) {
            // Atualiza o template
            await _repo.update(
              template
                  .copyWith(
                    totalInstallments: newTotal,
                    updatedAt: Nullable(DateTime.now()),
                  )
                  .toMap(),
              executor: txn,
            );

            // Ajusta todas as instâncias
            final allInstanceMaps = await _repo.findByTemplateId(
              templateId,
              executor: txn,
            );
            final allInstances = TransactionMapper.fromRows(allInstanceMaps);

            await _adjustInstallments(
              template: template.copyWith(totalInstallments: newTotal),
              allInstances: allInstances,
              newTotal: newTotal,
              executor: txn,
            );
          }
        }
      });
    } on TransactionException {
      rethrow;
    } on DatabaseException catch (_) {
      throw TransactionSaveException();
    }
  }

  Future<void> updateTransactionAndFuture(
    Transaction transaction,
    Transaction updatedTemplate,
  ) async {
    try {
      final db = await _dbHelper.database;
      await db.transaction((txn) async {
        final category = await _categoryService.ensureCategoryExists(
          updatedTemplate.category,
          executor: txn,
        );

        final templateToSave = updatedTemplate.copyWith(
          category: category,
          updatedAt: Nullable(DateTime.now()),
        );
        await _repo.update(templateToSave.toMap(), executor: txn);
        await _tagService.syncTagsForTransaction(
          templateToSave.id!,
          templateToSave.tags,
          executor: txn,
        );

        final instanceToSave = transaction.copyWith(
          category: category,
          updatedAt: Nullable(DateTime.now()),
        );
        await _repo.update(instanceToSave.toMap(), executor: txn);
        await _tagService.syncTagsForTransaction(
          instanceToSave.id!,
          instanceToSave.tags,
          executor: txn,
        );

        final allInstanceMaps = await _repo.findByTemplateId(
          templateToSave.id!,
          executor: txn,
        );
        final allInstances = TransactionMapper.fromRows(allInstanceMaps);

        final futureInstances = allInstances.where(
          (t) => t.id != transaction.id && t.date.isAfter(transaction.date),
        );
        for (final instance in futureInstances) {
          final updatedInstance = instance.copyWith(
            title: updatedTemplate.title,
            amount: updatedTemplate.amount,
            category: category,
            description: updatedTemplate.description,
            tags: updatedTemplate.tags,
            updatedAt: Nullable(DateTime.now()),
          );
          await _repo.update(updatedInstance.toMap(), executor: txn);
          await _tagService.syncTagsForTransaction(
            instance.id!,
            updatedTemplate.tags,
            executor: txn,
          );
        }

        final newTotal = updatedTemplate.totalInstallments;
        final isInstallment =
            newTotal != null && newTotal > 1 && !updatedTemplate.isRecurring;
        if (isInstallment) {
          // Atualiza o totalInstallments no template no DB antes de ajustar
          await _repo.update(
            templateToSave.copyWith(totalInstallments: newTotal).toMap(),
            executor: txn,
          );

          await _adjustInstallments(
            template: templateToSave,
            allInstances: allInstances, // contém todas, não só as futuras
            newTotal: newTotal,
            executor: txn,
          );
        }
      });
    } on TransactionException {
      rethrow;
    } on DatabaseException catch (_) {
      throw TransactionSaveException();
    }
  }

  Future<void> _adjustInstallments({
    required Transaction template,
    required List<Transaction> allInstances,
    required int newTotal,
    required sqflite.DatabaseExecutor executor,
  }) async {
    final sorted = List<Transaction>.from(allInstances)
      ..sort((a, b) => a.date.compareTo(b.date));
    final currentCount = sorted.length;

    if (newTotal == currentCount) return;

    if (newTotal < currentCount) {
      final toKeep = sorted.take(newTotal).toList();

      for (final t in sorted.skip(newTotal)) {
        await _repo.delete(t.id!, executor: executor);
      }

      for (int i = 0; i < toKeep.length; i++) {
        final updated = toKeep[i].copyWith(
          totalInstallments: newTotal,
          currentInstallment: i + 1,
          updatedAt: Nullable(DateTime.now()),
        );
        await _repo.update(updated.toMap(), executor: executor);
      }
    } else {
      for (int i = 0; i < sorted.length; i++) {
        await _repo.update(
          sorted[i]
              .copyWith(
                totalInstallments: newTotal,
                currentInstallment: i + 1,
                updatedAt: Nullable(DateTime.now()),
              )
              .toMap(),
          executor: executor,
        );
      }

      final lastDate = sorted.last.date;
      final now = DateTime.now();
      for (int i = currentCount; i < newTotal; i++) {
        final newDate = lastDate.addMonths(i - currentCount + 1);
        final newInstallment = template.copyWith(
          id: const Nullable(null),
          date: newDate,
          totalInstallments: newTotal,
          currentInstallment: i + 1,
          templateId: template.id!,
          isTemplate: false,
          isRecurring: false,
          lastGeneratedMonth: const Nullable(null),
          createdAt: now,
          updatedAt: const Nullable(null),
        );
        final newId = await _repo.insert(
          newInstallment.toMap(),
          executor: executor,
        );
        if (template.tags.isNotEmpty) {
          await _tagService.linkTagsToTransaction(
            newId,
            template.tags,
            executor: executor,
          );
        }
      }
    }
  }

  // ─── Deleção ────────────────────────────────────────────────────────────────

  Future<void> deleteTransaction(int id) async {
    try {
      await _repo.delete(id);
    } on DatabaseException catch (_) {
      throw TransactionDeleteException();
    }
  }

  // ─── Recorrência / Parcelamento ──────────────────────────────────────────────

  Future<void> processRecurringTransactions({
    sqflite.DatabaseExecutor? executor,
  }) async {
    final pendingMaps = await _repo.findPending(executor: executor);

    if (pendingMaps.isEmpty) return;
    final pendingTransactions = TransactionMapper.fromRows(pendingMaps);

    if (executor == null) {
      final db = await _dbHelper.database;
      await db.transaction(
        (txn) => _runRecurringLogic(txn, pendingTransactions),
      );
    } else {
      await _runRecurringLogic(executor, pendingTransactions);
    }
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
          id: const Nullable(null),
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
        await _repo.update(
          template.copyWith(lastGeneratedMonth: Nullable(currentMonth)).toMap(),
          executor: txn,
        );
      }
    }
  }

  Future<void> _runInstallmentLogic(
    sqflite.DatabaseExecutor txn,
    Transaction template,
  ) async {
    final now = DateTime.now();
    for (int i = 0; i < template.totalInstallments!; i++) {
      final installmentDate = template.date.addMonths(i);
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

  // ─── Utilitários ────────────────────────────────────────────────────────────

  Future<void> resetDatabase() async {
    final db = await _dbHelper.database;
    final dbPath = db.path;

    await _dbHelper.closeAndReset();

    final file = File(dbPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
