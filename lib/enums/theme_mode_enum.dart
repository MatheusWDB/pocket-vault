import 'package:flutter/material.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';

enum AppThemeModeEnum {
  system,
  light,
  dark;

  String displayName(AppLocalizations t) {
    return switch (this) {
      AppThemeModeEnum.system => t.system,
      AppThemeModeEnum.light => t.light,
      AppThemeModeEnum.dark => t.dark,
    };
  }

  const AppThemeModeEnum();
}

extension AppThemeModeEnumX on AppThemeModeEnum {
  ThemeMode toThemeMode() => switch (this) {
    AppThemeModeEnum.light => ThemeMode.light,
    AppThemeModeEnum.dark => ThemeMode.dark,
    AppThemeModeEnum.system => ThemeMode.system,
  };
}
