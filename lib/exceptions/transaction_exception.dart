sealed class TransactionException implements Exception {
  final String message;
  const TransactionException(this.message);

  @override
  String toString() => message;
}

class TransactionNotFoundException extends TransactionException {
  const TransactionNotFoundException() : super('Transação não encontrada');
}

class TransactionSaveException extends TransactionException {
  const TransactionSaveException(String message) : super('Erro ao salvar a transação');
}

class TransactionDeleteException extends TransactionException {
  const TransactionDeleteException(String message) : super('Erro ao excluir a transação');
}

class TransactionInvalidException extends TransactionException {
  const TransactionInvalidException(super.message);
}