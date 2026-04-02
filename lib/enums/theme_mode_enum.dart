import 'package:flutter/material.dart';

enum AppThemeModeEnum {
  system('Sistema'),
  light('Claro'),
  dark('Escuro');

  final String displayName;
  
  const AppThemeModeEnum(this.displayName);
}

extension AppThemeModeEnumX on AppThemeModeEnum {
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeModeEnum.light:
        return ThemeMode.light;
      case AppThemeModeEnum.dark:
        return ThemeMode.dark;
      case AppThemeModeEnum.system:
        return ThemeMode.system;
    }
  }
}
