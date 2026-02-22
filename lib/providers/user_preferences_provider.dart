import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
import 'package:pocket_vault/models/user_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_preferences_provider.g.dart';

@riverpod
class Preferences extends _$Preferences {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static const _userNamekey = 'user_name';
  static const _currencySymbolKey = 'currency_symbol';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _themeModeKey = 'theme_mode';
  static const _lastBackupKey = 'last_backup_at';

  @override
  UserPreferences build() {
    _loadFromStorage();

    return UserPreferences.initial();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await _prefs;

    final userName = prefs.getString(_userNamekey);
    final currencySymbolIndex = prefs.getInt(_currencySymbolKey);
    final biometricEnabled = prefs.getBool(_biometricEnabledKey);
    final themeIndex = prefs.getInt(_themeModeKey);
    final lastBackupMillis = prefs.getInt(_lastBackupKey);

    state = state.copyWith(
      userName: userName ?? state.userName,
      currencySymbol: currencySymbolIndex != null
          ? CurrencySymbolEnum.values[currencySymbolIndex]
          : state.currencySymbol,
      isBiometricEnabled: biometricEnabled ?? state.isBiometricEnabled,
      themeMode: themeIndex != null
          ? AppThemeModeEnum.values[themeIndex]
          : state.themeMode,
      lastBackupAt: lastBackupMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(lastBackupMillis)
          : state.lastBackupAt,
    );
  }

  Future<void> setName(String name) async {
    final prefs = await _prefs;

    state = state.copyWith(userName: name);
    await prefs.setString(_userNamekey, name);
  }

  Future<void> setCurrencySymbol(CurrencySymbolEnum symbol) async {
    final prefs = await _prefs;

    state = state.copyWith(currencySymbol: symbol);
    await prefs.setInt(_currencySymbolKey, symbol.index);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await _prefs;

    state = state.copyWith(isBiometricEnabled: enabled);
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  Future<void> setTheme(AppThemeModeEnum mode) async {
    final prefs = await _prefs;

    state = state.copyWith(themeMode: mode);
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> setLastBackup(DateTime date) async {
    final prefs = await _prefs;

    state = state.copyWith(lastBackupAt: date);
    await prefs.setInt(_lastBackupKey, date.millisecondsSinceEpoch);
  }
}
