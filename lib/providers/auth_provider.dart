import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    final isBiometricEnabled = ref.read(preferencesProvider).isBiometricEnabled;

    return isBiometricEnabled ? false : true;
  }

  void setAuthenticated(bool value) {
    if (value) state = value;
  }

  void logout() {
    final isBiometricEnabled = ref.read(preferencesProvider).isBiometricEnabled;

    if (isBiometricEnabled) state = false;
  }
}
