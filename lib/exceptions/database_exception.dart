sealed class DatabaseException implements Exception {
  const DatabaseException();
}

class RecordNotFoundException extends DatabaseException {
  const RecordNotFoundException();
}

class RecordInsertException extends DatabaseException {
  const RecordInsertException();
}

class RecordUpdateException extends DatabaseException {
  const RecordUpdateException();
}

class RecordDeleteException extends DatabaseException {
  const RecordDeleteException();
}

class RecordQueryException extends DatabaseException {
  const RecordQueryException();
}
