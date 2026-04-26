import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
import 'package:pocket_vault/models/user_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class Preferences extends _$Preferences {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static const _userNameKey  = 'user_name';
  static const _currencySymbolKey = 'currency_symbol';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _themeModeKey = 'theme_mode';
  static const _lastBackupKey = 'last_backup_at';
  static const _lastScreenKey  = 'last_screen';
  static const _lastTabKey  = 'last_tab';
  static const _lastTransactionIdKey  = 'last_transaction_id';

  @override
  UserPreferences build() {
    _loadFromStorage();

    return UserPreferences.initial();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await _prefs;

    final userName = prefs.getString(_userNameKey );
    final currencySymbolIndex = prefs.getInt(_currencySymbolKey);
    final biometricEnabled = prefs.getBool(_biometricEnabledKey);
    final themeIndex = prefs.getInt(_themeModeKey);
    final lastBackupMillis = prefs.getInt(_lastBackupKey);
    final lastScreenIndex = prefs.getInt(_lastScreenKey );
    final lastTabIndex = prefs.getInt(_lastTabKey );
    final lastTransactionId = prefs.getInt(_lastTransactionIdKey );

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
      lastScreen: lastScreenIndex != null
          ? AppScreenEnum.values[lastScreenIndex]
          : state.lastScreen,
      lastTab:
          (lastScreenIndex == AppScreenEnum.home.index && lastTabIndex != null)
          ? AppTabEnum.values[lastTabIndex]
          : state.lastTab,
      lastTransactionDetailId:
          lastTransactionId ?? state.lastTransactionDetailId,
    );
  }

  Future<void> setName(String name) async {
    final prefs = await _prefs;

    state = state.copyWith(userName: name);
    await prefs.setString(_userNameKey , name);
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

  Future<void> setLastScreen(AppScreenEnum? screen) async {
    final prefs = await _prefs;

    state = state.copyWith(lastScreen: screen);

    if (screen != null) {
      await prefs.setInt(_lastScreenKey , screen.index);
    } else {
      await prefs.remove(_lastScreenKey );
    }
  }

  Future<void> setLastTab(AppTabEnum? tab) async {
    final prefs = await _prefs;

    state = state.copyWith(lastTab: tab);

    if (tab != null) {
      await prefs.setInt(_lastTabKey , tab.index);
    } else {
      await prefs.remove(_lastTabKey );
    }
  }

  Future<void> setLastTransactionDetailId(int? id) async {
    final prefs = await _prefs;

    state = state.copyWith(lastTransactionDetailId: id);

    if (id != null) {
      await prefs.setInt(_lastTransactionIdKey , id);
    } else {
      await prefs.remove(_lastTransactionIdKey );
    }
  }
}
