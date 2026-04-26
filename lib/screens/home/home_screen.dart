import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/navigation/route_observer.dart';
import 'package:pocket_vault/providers/loading_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/home/tabs/budget/budget_tab.dart';
import 'package:pocket_vault/screens/home/tabs/dashboard/dashboard_tab.dart';
import 'package:pocket_vault/screens/home/tabs/report/report_tab.dart';
import 'package:pocket_vault/screens/home/tabs/transaction/transaction_tab.dart';
import 'package:pocket_vault/screens/home/widgets/custom_bottom_app_bar.dart';
import 'package:pocket_vault/screens/settings/settings_screen.dart';
import 'package:pocket_vault/screens/transaction_form/transaction_form_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  late int _activeMenu;

  void _onChangeMenu(int index) {
    if (_activeMenu != index) {
      ref
          .read(preferencesProvider.notifier)
          .setLastTab(AppTabEnum.values[index]);

      final filterNotifier = ref.read(transactionFilterProvider.notifier);

      (index == 1) ? filterNotifier.clear() : filterNotifier.standardFilter();

      setState(() {
        _activeMenu = index;
      });
    }
  }

  void _onPressedSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  void _onPressedTransactionForm() {
    ref.read(preferencesProvider.notifier).setLastTransactionDetailId(null);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionFormScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    final lastTab =
        ref.read(preferencesProvider).lastTab ?? AppTabEnum.dashboard;

    _activeMenu = lastTab.index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(preferencesProvider.notifier).setLastScreen(AppScreenEnum.home);
  }

  @override
  void didPush() {
    ref.read(preferencesProvider.notifier).setLastScreen(AppScreenEnum.home);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final loading = ref.watch(loadingStateProvider);

    final tabs = [
      (t.summary, DashboardTab()),
      (t.transactions, TransactionTab()),
      (t.budgets, BudgetTab()),
      (t.report, ReportTab()),
    ];

    final (title, tab) = tabs[_activeMenu];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                onPressed: () => _onPressedSettings(),
                icon: const Icon(LucideIcons.settings),
              ),
            ],
            actionsPadding: const EdgeInsets.all(8.0),
          ),
          bottomNavigationBar: CustomBottomAppBar(
            activeIndex: _activeMenu,
            onDestinationSelected: _onChangeMenu,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onPressedTransactionForm(),
            shape: const CircleBorder(),
            child: const Icon(LucideIcons.circlePlus, size: 35.0),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: SafeArea(
            child: Padding(padding: const EdgeInsets.all(8.0), child: tab),
          ),
        ),
        if (loading) ...[
          ModalBarrier(dismissible: false, color: Colors.black45),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
