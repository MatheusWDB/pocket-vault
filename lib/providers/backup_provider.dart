import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/database_provider.dart';
import 'package:pocket_vault/providers/tag_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/services/backup_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_provider.g.dart';

@riverpod
BackupService backupService(Ref ref) {
  return BackupService(
    ref.watch(databaseHelperProvider),
    ref.read(categoryServiceProvider),
    ref.read(tagServiceProvider),
    ref.read(transactionServiceProvider),
  );
}
