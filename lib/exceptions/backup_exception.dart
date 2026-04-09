sealed class BackupException implements Exception {
  final String message;
  const BackupException(this.message);

  @override
  String toString() => message;
}

class BackupCancelledException extends BackupException {
  const BackupCancelledException() : super('Operação cancelada pelo usuário');
}

class BackupGenerationException extends BackupException {
  const BackupGenerationException() : super('Erro ao gerar arquivo de backup');
}

class BackupSaveException extends BackupException {
  const BackupSaveException() : super('Erro ao salvar o backup no dispositivo');
}

class BackupShareException extends BackupException {
  const BackupShareException() : super('Erro ao compartilhar o backup');
}

class BackupInvalidException extends BackupException {
  const BackupInvalidException(super.message);
}

class BackupImportException extends BackupException {
  const BackupImportException() : super('Erro ao importar o arquivo de backup');
}

class BackupRestoreException extends BackupException {
  const BackupRestoreException() : super('Erro ao restaurar o backup');
}
