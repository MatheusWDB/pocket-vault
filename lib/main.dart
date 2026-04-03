import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/l10n/l10n.dart';
import 'package:pocket_vault/providers/auth_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/auth/auth_screen.dart';
import 'package:pocket_vault/services/auth_service.dart';
import 'package:pocket_vault/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await DatabaseHelper.instance.database;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(preferencesProvider.notifier).setLastScreen(AppScreenEnum.home);
    ref.read(preferencesProvider.notifier).setLastTab(AppTabEnum.dashboard);
    ref.read(preferencesProvider.notifier).setLastTransactionDetailId(null);
    ref.read(transactionListProvider.notifier).processRecurring();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ref.read(authStateProvider.notifier).logout();

      AuthService().cancelAuthentication();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(preferencesProvider).themeMode;
    final isAuthenticated = ref.watch(authStateProvider);
    final lastScreen = ref.read(preferencesProvider).lastScreen;
    Widget home = lastScreen.toScreen();

    if (lastScreen == AppScreenEnum.details ||
        lastScreen == AppScreenEnum.form) {
      final lastTransactionId = ref
          .read(preferencesProvider)
          .lastTransactionDetailId;

      final transactionDetails = ref
          .read(transactionByIdProvider(id: lastTransactionId))
          .value;

      home = lastScreen.toScreen(transactionDetails);
    }

    return MaterialApp(
      title: 'PocketVault Personal Finance',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: L10n.all,
      themeMode: themeMode.toThemeMode(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: home,
      builder: (context, child) {
        return Stack(
          children: [?child, if (!isAuthenticated) const AuthScreen()],
        );
      },
    );
  }
}
