sealed class AuthException implements Exception {
  const AuthException();
}

class AuthFailedException extends AuthException {
  const AuthFailedException();
}

class AuthCancelledException extends AuthException {
  const AuthCancelledException();
}

class AuthUnavailableException extends AuthException {
  const AuthUnavailableException();
}
