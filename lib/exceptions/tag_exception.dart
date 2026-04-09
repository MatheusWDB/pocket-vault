sealed class TagException implements Exception {
  final String message;
  const TagException(this.message);

  @override
  String toString() => message;
}

class TagNotFoundException extends TagException {
  const TagNotFoundException() : super('Tag não encontrada');
}

class TagSaveException extends TagException {
  const TagSaveException(String message) : super('Erro ao salvar a tag');
}

class TagDeleteException extends TagException {
  const TagDeleteException() : super('Erro ao excluir a tag');
}