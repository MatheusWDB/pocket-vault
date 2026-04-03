import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF1E3A5F);
  static const _primaryLight = Color(0xFF2D5491);
  static const _primaryDark = Color(0xFF3D6496);

  static const _income = Color(0xFF16A34A);
  static const _incomeBg = Color(0xFFDCFCE7);
  static const _expense = Color(0xFFDC2626);
  static const _expenseBg = Color(0xFFFEE2E2);
  static const _warning = Color(0xFFF59E0B);

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD0E4FF),
      onPrimaryContainer: Color(0xFF0A1F38),

      secondary: _income,
      onSecondary: Colors.white,
      secondaryContainer: _incomeBg,
      onSecondaryContainer: Color(0xFF0A3D1F),

      tertiary: _expense,
      onTertiary: Colors.white,
      tertiaryContainer: _expenseBg,
      onTertiaryContainer: Color(0xFF5C0A0A),

      error: _expense,
      surface: Colors.white,
      onSurface: Color(0xFF0F172A),
      onSurfaceVariant: Color(0xFF64748B),

      outline: Color(0xFFCBD5E1),
      outlineVariant: Color(0xFFE2E8F0),
    ),

    scaffoldBackgroundColor: const Color(0xFFF8FAFC),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0F172A),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Color(0x14000000),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),

    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF64748B)),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 0.5,
      space: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primary,
        side: const BorderSide(color: _primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: CircleBorder(),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFCBD5E1),
      selectedColor: _primaryLight,
      deleteIconColor: Colors.white70,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primary,
      linearTrackColor: Color(0xFFE2E8F0),
    ),

    extensions: const [AppColors.light],

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryLight,
      unselectedItemColor: Colors.black54,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: _primaryDark,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF0C2440),
      onPrimaryContainer: const Color(0xFFB5D4F4),

      secondary: const Color(0xFF86EFAC),
      onSecondary: const Color(0xFF0A3D1F),
      secondaryContainer: const Color(0xFF0F3320),
      onSecondaryContainer: const Color(0xFFBBF7D0),

      tertiary: const Color(0xFFFCA5A5),
      onTertiary: const Color(0xFF5C0A0A),
      tertiaryContainer: const Color(0xFF3D0F0F),
      onTertiaryContainer: const Color(0xFFFECACA),

      error: const Color(0xFFFCA5A5),
      surface: const Color(0xFF1E2D3D),
      onSurface: const Color(0xFFF1F5F9),
      onSurfaceVariant: const Color(0xFF94A3B8),

      outline: const Color(0xFF334155),
      outlineVariant: const Color(0xFF1E293B),
    ),

    scaffoldBackgroundColor: const Color(0xFF0F1824),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E2D3D),
      foregroundColor: Color(0xFFF1F5F9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E2D3D),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
    ),

    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF94A3B8)),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E293B),
      thickness: 0.5,
      space: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryDark, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryDark,
        side: const BorderSide(color: _primaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: CircleBorder(),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1E293B),
      selectedColor: _primaryDark,
      deleteIconColor: Colors.white70,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      side: const BorderSide(color: Color(0xFF334155)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: _primaryDark,
      linearTrackColor: Color(0xFF1E293B),
    ),

    extensions: const [AppColors.dark],

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E2D3D),
      selectedItemColor: _primaryDark,
      unselectedItemColor: Colors.white70,
    ),
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.income,
    required this.incomeBg,
    required this.expense,
    required this.expenseBg,
    required this.warning,
    required this.warningBg,
    required this.balanceCardBg,
    required this.balanceCardSurface,
  });

  final Color income;
  final Color incomeBg;
  final Color expense;
  final Color expenseBg;
  final Color warning;
  final Color warningBg;
  final Color balanceCardBg;
  final Color balanceCardSurface;

  static const light = AppColors(
    income: Color(0xFF16A34A),
    incomeBg: Color(0xFFDCFCE7),
    expense: Color(0xFFDC2626),
    expenseBg: Color(0xFFFEE2E2),
    warning: Color(0xFFF59E0B),
    warningBg: Color(0xFFFEF9C3),
    balanceCardBg: Color(0xFF1E3A5F),
    balanceCardSurface: Color(0xFF2D5491),
  );

  static const dark = AppColors(
    income: Color(0xFF86EFAC),
    incomeBg: Color(0xFF0F3320),
    expense: Color(0xFFFCA5A5),
    expenseBg: Color(0xFF3D0F0F),
    warning: Color(0xFFFCD34D),
    warningBg: Color(0xFF3D2E00),
    balanceCardBg: Color(0xFF0C2440),
    balanceCardSurface: Color(0xFF1E2D3D),
  );

  @override
  AppColors copyWith({
    Color? income,
    Color? incomeBg,
    Color? expense,
    Color? expenseBg,
    Color? warning,
    Color? warningBg,
    Color? balanceCardBg,
    Color? balanceCardSurface,
  }) => AppColors(
    income: income ?? this.income,
    incomeBg: incomeBg ?? this.incomeBg,
    expense: expense ?? this.expense,
    expenseBg: expenseBg ?? this.expenseBg,
    warning: warning ?? this.warning,
    warningBg: warningBg ?? this.warningBg,
    balanceCardBg: balanceCardBg ?? this.balanceCardBg,
    balanceCardSurface: balanceCardSurface ?? this.balanceCardSurface,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      income: Color.lerp(income, other.income, t)!,
      incomeBg: Color.lerp(incomeBg, other.incomeBg, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      expenseBg: Color.lerp(expenseBg, other.expenseBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      balanceCardBg: Color.lerp(balanceCardBg, other.balanceCardBg, t)!,
      balanceCardSurface: Color.lerp(
        balanceCardSurface,
        other.balanceCardSurface,
        t,
      )!,
    );
  }
}
