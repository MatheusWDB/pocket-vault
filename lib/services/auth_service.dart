import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:pocket_vault/exceptions/auth_exception.dart';

class AuthService {
  static final _auth = LocalAuthentication();
  static bool _isAuthenticating = false;

  Future<bool> checkBiometrics() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (_) {
      throw const AuthUnavailableException();
    }
  }

  Future<void> authenticate() async {
    if (_isAuthenticating) throw const AuthCancelledException();
    _isAuthenticating = true;

    try {
      final result = await _auth.authenticate(
        authMessages: [
          AndroidAuthMessages(signInTitle: 'PocketVault', signInHint: ''),
          IOSAuthMessages(localizedFallbackTitle: 'PocketVault'),
        ],
        localizedReason: 'Sua soberania financeira começa aqui.',
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

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final availableBiometrics = <BiometricType>[];
    try {
      final biometrics = await _auth.getAvailableBiometrics();
      availableBiometrics.addAll(biometrics);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return availableBiometrics;
  }

  Future<bool> authenticateWithBiometrics() async {
    var authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason:
            'Scan your fingerdebugPrint (or face or whatever) to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      debugPrint(e.toString());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return authenticated;
  }

  Future<void> cancelAuthentication() async {
    _isAuthenticating = false;
    await _auth.stopAuthentication();
  }
}
