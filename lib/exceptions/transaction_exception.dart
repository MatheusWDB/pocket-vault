sealed class TransactionException implements Exception {
  const TransactionException();
}

class TransactionNotFoundException extends TransactionException {
  const TransactionNotFoundException();
}

class TransactionSaveException extends TransactionException {
  const TransactionSaveException();
}

class TransactionDeleteException extends TransactionException {
  const TransactionDeleteException();
}

class TransactionInvalidValueException extends TransactionException {
  const TransactionInvalidValueException();
}

class TransactionInvalidTitleException extends TransactionException {
  const TransactionInvalidTitleException();
}

class TransactionInvalidCategoryException extends TransactionException {
  const TransactionInvalidCategoryException();
}
