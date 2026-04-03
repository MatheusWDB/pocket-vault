import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/screen_enum.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/home/tabs/budget/budget_tab.dart';
import 'package:pocket_vault/screens/home/tabs/dashboard/dashboard_tab.dart';
import 'package:pocket_vault/screens/home/tabs/report/report_tab.dart';
import 'package:pocket_vault/screens/home/tabs/transaction/transaction_tab.dart';
import 'package:pocket_vault/screens/home/widgets/custom_bottom_app_bar.dart';
import 'package:pocket_vault/screens/settings/settings_screen.dart';
import 'package:pocket_vault/screens/transacation_form/transaction_form_screen.dart';
import 'package:pocket_vault/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _activeMenu;

  final _tabs = const [
    ('Resumo', DashboardTab()),
    ('Transações', TransactionTab()),
    ('Orçamentos', BudgetTab()),
    ('Relatório', ReportTab()),
  ];

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

  @override
  void initState() {
    super.initState();
    final lastTab =
        ref.read(preferencesProvider).lastTab ?? AppTabEnum.dashboard;

    _activeMenu = lastTab.index;
  }

  @override
  Widget build(BuildContext context) {
    final (title, tab) = _tabs[_activeMenu];
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(preferencesProvider.notifier)
                  .setLastScreen(AppScreenEnum.settings);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: const Icon(LucideIcons.settings),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever, color: appColors.warning),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Resetar Banco?'),
                  content: const Text(
                    'Isso apagará TODAS as transações e categorias.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(
                        'Resetar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final service = ref.read(transactionServiceProvider);
                await service.resetDatabase();

                ref.invalidate(transactionListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 750),
                      content: Text(
                        'Banco de dados resetado! Reinicie o app se necessário.',
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
        actionsPadding: const EdgeInsets.all(8.0),
      ),
      bottomNavigationBar: MyCustomBottomAppBar(
        activeIndex: _activeMenu,
        onDestinationSelected: _onChangeMenu,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(preferencesProvider.notifier)
              .setLastTransactionDetailId(null);

          ref
              .read(preferencesProvider.notifier)
              .setLastScreen(AppScreenEnum.form);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionFormScreen(),
            ),
          );
        },

        shape: const CircleBorder(),
        child: const Icon(LucideIcons.circlePlus, size: 35.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(8.0), child: tab),
      ),
    );
  }
}
