sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthFailedException extends AuthException {
  const AuthFailedException() : super('Autenticação falhou');
}

class AuthCancelledException extends AuthException {
  const AuthCancelledException() : super('Autenticação cancelada pelo usuário');
}

class AuthUnavailableException extends AuthException {
  const AuthUnavailableException()
      : super('Biometria não disponível neste dispositivo');
}