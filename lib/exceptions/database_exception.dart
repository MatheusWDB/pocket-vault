sealed class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => message;
}

class RecordNotFoundException extends DatabaseException {
  const RecordNotFoundException(String entity)
    : super('$entity não encontrado');
}

class RecordInsertException extends DatabaseException {
  const RecordInsertException(String entity) : super('Erro ao inserir $entity');
}

class RecordUpdateException extends DatabaseException {
  const RecordUpdateException(String entity)
    : super('Erro ao atualizar $entity');
}

class RecordDeleteException extends DatabaseException {
  const RecordDeleteException(String entity) : super('Erro ao excluir $entity');
}

class RecordQueryException extends DatabaseException {
  const RecordQueryException(String entity) : super('Erro ao buscar $entity');
}
