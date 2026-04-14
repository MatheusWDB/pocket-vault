import 'package:pocket_vault/exceptions/auth_exception.dart';
import 'package:pocket_vault/exceptions/backup_exception.dart';
import 'package:pocket_vault/exceptions/category_exception.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:pocket_vault/exceptions/tag_exception.dart';
import 'package:pocket_vault/exceptions/transaction_exception.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';

extension AppLocalizationsX on AppLocalizations {
  String fromException(Exception e) {
    return switch (e) {
      // Auth
      AuthFailedException() => authFailed,
      AuthCancelledException() => authCancelled,
      AuthUnavailableException() => biometryUnavailable,

      // Backup
      BackupCancelledException() => operationCancelled,
      BackupGenerationException() => errorBackupGenerate,
      BackupSaveException() => errorBackupSave,
      BackupShareException() => errorBackupShare,
      BackupImportException() => errorBackupImport,
      BackupRestoreException() => errorBackupRestore,
      BackupInvalidNoCategoriesException() => invalidBackupNoCategories,
      BackupInvalidNoTransactionsException() => invalidBackupNoTransactions,

      // Category
      CategoryNotFoundException() => categoryNotFound,
      CategorySaveException() => errorCategorySave,
      CategoryDeleteException() => errorDeleteCategoryLinked,

      // Database
      RecordInsertException() => errorInsert,
      RecordUpdateException() => errorUpdate,
      RecordDeleteException() => errorDelete,
      RecordQueryException() => errorFetch,

      // Tag
      TagNotFoundException() => tagNotFound,
      TagSaveException() => errorTagSave,
      TagDeleteException() => errorTagDelete,

      // Transaction
      TransactionNotFoundException() => transactionNotFound,
      TransactionSaveException() => errorTransactionSave,
      TransactionDeleteException() => errorTransactionDelete,
      TransactionInvalidValueException() => valueGreaterThanZero,
      TransactionInvalidTitleException() => insertTitle,
      TransactionInvalidCategoryException() => defineCategory,

      _ => e.toString(),
    };
  }
}
