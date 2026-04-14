sealed class BackupException implements Exception {
  const BackupException();
}

class BackupCancelledException extends BackupException {
  const BackupCancelledException();
}

class BackupGenerationException extends BackupException {
  const BackupGenerationException();
}

class BackupSaveException extends BackupException {
  const BackupSaveException();
}

class BackupShareException extends BackupException {
  const BackupShareException();
}

class BackupInvalidNoCategoriesException extends BackupException {
  const BackupInvalidNoCategoriesException();
}

class BackupInvalidNoTransactionsException extends BackupException {
  const BackupInvalidNoTransactionsException();
}

class BackupImportException extends BackupException {
  const BackupImportException();
}

class BackupRestoreException extends BackupException {
  const BackupRestoreException();
}
