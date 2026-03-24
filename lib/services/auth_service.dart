import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';

class AuthService {
  static final _auth = LocalAuthentication();
  static bool _isAuthenticating = false;

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      canCheckBiometrics =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return canCheckBiometrics;
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

  Future<bool> authenticate() async {
    if (_isAuthenticating) return false;
    _isAuthenticating = true;

    try {
      final result = await _auth.authenticate(
        authMessages: <AuthMessages>[
          AndroidAuthMessages(signInTitle: 'PocketVault', signInHint: ''),
          IOSAuthMessages(localizedFallbackTitle: 'PocketVault'),
        ],
        localizedReason: 'Sua soberania financeira começa aqui.',
        persistAcrossBackgrounding: true,
      );

      _isAuthenticating = false;
      return result;
    } on LocalAuthException catch (e) {
      debugPrint(e.toString());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    _isAuthenticating = false;
    return false;
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
