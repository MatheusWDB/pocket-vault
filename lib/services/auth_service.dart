import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:pocket_vault/exceptions/auth_exception.dart';

class AuthService {
  final LocalAuthentication _auth;
  static const String appName = 'PocketVault';

  AuthService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  static bool _isAuthenticating = false;
  Future<bool> checkBiometrics() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (_) {
      throw const AuthUnavailableException();
    }
  }

  Future<void> authenticate({required String localizedReason}) async {
    if (_isAuthenticating) throw const AuthCancelledException();
    _isAuthenticating = true;

    try {
      final result = await _auth.authenticate(
        authMessages: [
          AndroidAuthMessages(signInTitle: appName, signInHint: ''),
          IOSAuthMessages(localizedFallbackTitle: appName),
        ],
        localizedReason: localizedReason,
        persistAcrossBackgrounding: true,
      );

      if (!result) throw const AuthFailedException();
    } on AuthException {
      rethrow;
    } on PlatformException catch (_) {
      throw const AuthFailedException();
    } finally {
      _isAuthenticating = false;
    }
  }

  Future<void> cancelAuthentication() async {
    _isAuthenticating = false;
    await _auth.stopAuthentication();
  }
}
