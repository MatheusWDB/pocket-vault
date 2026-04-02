import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';

class UserPreferences {
  final String? userName;
  final bool isBiometricEnabled;
  final CurrencySymbolEnum currencySymbol;
  final AppThemeModeEnum themeMode;
  final DateTime? lastBackupAt;
  final AppScreenEnum lastScreen;
  final AppTabEnum? lastTab;
  final int? lastTransactionDetailId;

  const UserPreferences({
    required this.lastScreen,
    required this.themeMode,
    required this.isBiometricEnabled,
    required this.currencySymbol,
    this.userName,
    this.lastBackupAt,
    this.lastTab,
    this.lastTransactionDetailId,
  });

  UserPreferences copyWith({
    String? userName,
    bool? isBiometricEnabled,
    CurrencySymbolEnum? currencySymbol,
    AppThemeModeEnum? themeMode,
    DateTime? lastBackupAt,
    AppScreenEnum? lastScreen,
    AppTabEnum? lastTab,
    int? lastTransactionDetailId,
  }) {
    return UserPreferences(
      userName: userName ?? this.userName,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeMode: themeMode ?? this.themeMode,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      lastScreen: lastScreen ?? this.lastScreen,
      lastTab: lastTab ?? this.lastTab,
      lastTransactionDetailId: lastTransactionDetailId ?? this.lastTransactionDetailId,
    );
  }

  factory UserPreferences.initial() => const UserPreferences(
    isBiometricEnabled: true,
    currencySymbol: CurrencySymbolEnum.brl,
    themeMode: AppThemeModeEnum.system,
    lastScreen: AppScreenEnum.home,
    lastTab: AppTabEnum.dashboard,
  );
}
