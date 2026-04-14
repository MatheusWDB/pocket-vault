sealed class CategoryException implements Exception {
  const CategoryException();
}

class CategoryNotFoundException extends CategoryException {
  const CategoryNotFoundException();
}

class CategorySaveException extends CategoryException {
  const CategorySaveException();
}

class CategoryDeleteException extends CategoryException {
  const CategoryDeleteException();
}
