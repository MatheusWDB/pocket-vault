import 'package:pocket_vault/enums/currency_symbol_enum.dart';

class UserPreferences {
  final String userName;
  final bool isBiometricEnabled;
  final CurrencySymbolEnum currencySymbol;
  final DateTime? lastBackupDate;

  const UserPreferences({
    required this.userName,
    required this.isBiometricEnabled,
    required this.currencySymbol,
    this.lastBackupDate,
  });

  UserPreferences copyWith({
    String? userName,
    bool? isBiometricEnabled,
    CurrencySymbolEnum? currencySymbol,
    DateTime? lastBackupDate,
  }) {
    return UserPreferences(
      userName: userName ?? this.userName,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  factory UserPreferences.initial() => const UserPreferences(
    userName: '',
    isBiometricEnabled: true,
    currencySymbol: CurrencySymbolEnum.brl,
  );
}
