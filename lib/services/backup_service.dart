import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/dto/backup_data.dart';
import 'package:pocket_vault/exceptions/backup_exception.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:pocket_vault/services/tag_service.dart';
import 'package:pocket_vault/services/transaction_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  final DatabaseHelper dbHelper;

  final CategoryService categoryService;
  final TagService tagService;
  final TransactionService transactionService;

  BackupService(
    this.dbHelper,
    this.categoryService,
    this.tagService,
    this.transactionService,
  );

  static final tableT = DatabaseHelper.tableTransaction;
  static final tableC = DatabaseHelper.tableCategory;
  static final tableTg = DatabaseHelper.tableTag;
  static final tableTT = DatabaseHelper.tableTransactionTags;

  static final columnRelTransactionId = DatabaseHelper.columnRelTransactionId;
  static final columnRelTagId = DatabaseHelper.columnRelTagId;

  Future<File> _generateBackupFile(Directory dir) async {
    try {
      final categories = await categoryService.getAllCategories();
      final transactions = await transactionService.getAllTransactions();
      final tags = await tagService.getAllTags();

      final backup = BackupData(
        categories: categories,
        transactions: transactions,
        tags: tags,
      );

      final now = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${dir.path}/pocket_vault_backup_$now.dat');
      await file.writeAsString(backup.toJson());

      return file;
    } catch (_) {
      throw const BackupGenerationException();
    }
  }

  Future<void> shareBackup([Directory? directory]) async {
    try {
      final Directory dir = directory ?? await getTemporaryDirectory();
      final File file = await _generateBackupFile(dir);

      final result = await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Backup PocketVault'),
      );

      if (result.status == ShareResultStatus.dismissed) {
        throw const BackupCancelledException();
      }
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupShareException();
    }
  }

  Future<void> saveBackup() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = await _generateBackupFile(dir);

      final bytes = await file.readAsBytes();
      final now = DateTime.now().toIso8601String().replaceAll(':', '-');

      final path = await FileSaver.instance.saveAs(
        name: 'pocket_vault_backup_$now',
        bytes: bytes,
        fileExtension: 'dat',
        mimeType: MimeType.other,
      );

      if (path == null || path.isEmpty) {
        throw const BackupCancelledException();
      }
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupSaveException();
    }
  }

  Future<BackupData> importBackup() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['dat'],
      );

      final filePath = result?.files.single.path;

      if (result == null || filePath == null) {
        throw const BackupCancelledException();
      }

      final jsonString = await File(filePath).readAsString();
      return BackupData.fromJson(jsonString);
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupImportException();
    }
  }

  Future<BackupData?> importFromAppFolder() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final files = dir
        .listSync()
        .whereType<File>()
        .where(
          (f) =>
              f.path.endsWith('.dat') &&
              f.path.contains('pocket_vault_backup_'),
        )
        .toList();

    if (files.isEmpty) return null;

    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    final file = files.first;

    final String jsonString = await file.readAsString();

    return BackupData.fromJson(jsonString);
  }

  Future<void> replaceAll(BackupData backup) async {
    if (backup.categories.isEmpty) {
      throw const BackupInvalidNoCategoriesException();
    }
    if (backup.transactions.isEmpty) {
      throw const BackupInvalidNoTransactionsException();
    }

    try {
      final db = await dbHelper.database;

      await db.transaction((txn) async {
        final batch = txn.batch();

        batch.delete(tableTT);
        batch.delete(tableT);
        batch.delete(tableTg);
        batch.delete(tableC);

        for (final category in backup.categories) {
          batch.insert(tableC, category.toMap());
        }
        for (final tag in backup.tags) {
          batch.insert(tableTg, tag.toMap());
        }
        for (final transaction in backup.transactions) {
          batch.insert(
            tableT,
            transaction.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          for (final tag in transaction.tags) {
            batch.insert(tableTT, {
              columnRelTransactionId: transaction.id,
              columnRelTagId: tag.id,
            });
          }
        }

        await batch.commit(noResult: true, continueOnError: false);
        await _fixSequences(txn);
      });
    } catch (_) {
      throw const BackupRestoreException();
    }
  }

  Future<void> _fixSequences(DatabaseExecutor db) async {
    final tables = [tableC, tableT, tableTg];

    for (final table in tables) {
      await db.rawUpdate(
        '''
          UPDATE sqlite_sequence
          SET seq = COALESCE((SELECT MAX(id) FROM $table), 0)
          WHERE name = ?
        ''',
        [table],
      );
    }
  }
}
