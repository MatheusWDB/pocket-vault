import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/enums/theme_mode_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/l10n/l10n.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/auth_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/auth/auth_screen.dart';
import 'package:pocket_vault/services/auth_service.dart';
import 'package:pocket_vault/theme/app_theme.dart';

class PocketVaultApp extends ConsumerStatefulWidget {
  const PocketVaultApp({super.key});

  @override
  ConsumerState<PocketVaultApp> createState() => _PocketVaultAppState();
}

class _PocketVaultAppState extends ConsumerState<PocketVaultApp>
    with WidgetsBindingObserver {
  DateTime? _pausedAt;
  static const _lockTimeout = Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final preferencesNotifier = ref.read(preferencesProvider.notifier);

    preferencesNotifier.setLastScreen(AppScreenEnum.home);
    preferencesNotifier.setLastTab(AppTabEnum.dashboard);
    preferencesNotifier.setLastTransactionDetailId(null);
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
      _pausedAt = DateTime.now();
      AuthService().cancelAuthentication();
    }

    if (state == AppLifecycleState.resumed) {
      final pausedAt = _pausedAt;

      if (pausedAt != null) {
        final elapsed = DateTime.now().difference(pausedAt);

        if (elapsed > _lockTimeout) {
          ref.read(authStateProvider.notifier).logout();
        }
      }

      _pausedAt = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'PocketVault Personal Finance';

    final themeMode = ref.watch(preferencesProvider).themeMode;
    final isAuthenticated = ref.watch(authStateProvider);
    final readPreferences = ref.read(preferencesProvider);

    final lastScreen = readPreferences.lastScreen;
    Widget home = lastScreen.toScreen();

    if (lastScreen == AppScreenEnum.details ||
        lastScreen == AppScreenEnum.form) {
      final lastTransactionId = readPreferences.lastTransactionDetailId;

      final transactionDetails = ref
          .watch(transactionByIdProvider(lastTransactionId))
          .value;

      home = lastScreen.toScreen(transactionDetails);
    }

    return MaterialApp(
      title: appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: L10n.all,
      themeMode: themeMode.toThemeMode(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      navigatorObservers: [appRouteObserver],
      home: home,
      builder: (context, child) {
        return Stack(
          children: [?child, if (!isAuthenticated) const AuthScreen()],
        );
      },
    );
  }
}
