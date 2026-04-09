sealed class CategoryException implements Exception {
  final String message;
  const CategoryException(this.message);

  @override
  String toString() => message;
}

class CategoryNotFoundException extends CategoryException {
  const CategoryNotFoundException() : super('Categoria não encontrada');
}

class CategorySaveException extends CategoryException {
  const CategorySaveException(String message) : super('Erro ao salvar a categoria');
}

class CategoryDeleteException extends CategoryException {
  const CategoryDeleteException()
    : super('Não é possível excluir uma categoria com transações vinculadas');
}
