import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';

class UserPreferences {
  final String? userName;
  final bool isBiometricEnabled;
  final CurrencySymbolEnum currencySymbol;
  final AppThemeModeEnum themeMode;
  final DateTime? lastBackupAt;

  const UserPreferences({
    required this.themeMode,
    required this.isBiometricEnabled,
    required this.currencySymbol,
    this.userName,
    this.lastBackupAt,
  });

  UserPreferences copyWith({
    String? userName,
    bool? isBiometricEnabled,
    CurrencySymbolEnum? currencySymbol,
    AppThemeModeEnum? themeMode,
    DateTime? lastBackupAt,
  }) {
    return UserPreferences(
      userName: userName ?? this.userName,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeMode: themeMode ?? this.themeMode,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }

  factory UserPreferences.initial() => const UserPreferences(
    isBiometricEnabled: true,
    currencySymbol: CurrencySymbolEnum.brl,
    themeMode: AppThemeModeEnum.system,
  );
}
