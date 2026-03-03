import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/screens/home/tabs/dashboard/dashboard_tab.dart';
import 'package:pocket_vault/screens/home/tabs/transactions/transaction_tab.dart';
import 'package:pocket_vault/screens/home/widgets/custom_bottom_app_bar.dart';
import 'package:pocket_vault/screens/transacationForm/transaction_form_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _activeMenu = 0;

  String _buildTitle() {
    switch (_activeMenu) {
      case 1:
        return 'Transações';
      case 2:
        return 'Orçamentos';
      case 3:
        return 'Evolução';
      default:
        return 'Resumo';
    }
  }

  Widget _buildTap() {
    switch (_activeMenu) {
      case 1:
        return TransactionTab();
      case 2:
        return Center(child: Text('budgets'));
      case 3:
        return Center(child: Text('reports'));
      default:
        return DashboardTab();
    }
  }

  void _onChangeMenu(int index) {
    if (_activeMenu != index) {
      final filterNotifier = ref.read(transactionFilterProvider.notifier);

      (index == 0) ? filterNotifier.standardFilter() : filterNotifier.clear();

      setState(() {
        _activeMenu = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_buildTitle()),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(LucideIcons.settings)),
        ],
        actionsPadding: const EdgeInsets.all(8.0),
      ),
      bottomNavigationBar: MyCustomBottomAppBar(
        activeIndex: _activeMenu,
        onDestinationSelected: _onChangeMenu,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionFormScreen()),
        ),
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(
          LucideIcons.circlePlus,
          color: Colors.white,
          size: 35.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(8.0), child: _buildTap()),
      ),
    );
  }
}
