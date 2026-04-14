sealed class TagException implements Exception {
  const TagException();
}

class TagNotFoundException extends TagException {
  const TagNotFoundException();
}

class TagSaveException extends TagException {
  const TagSaveException();
}

class TagDeleteException extends TagException {
  const TagDeleteException();
}
