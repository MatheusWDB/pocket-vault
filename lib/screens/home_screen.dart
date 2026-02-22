import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/widgets/custom_bottom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeMenu = 0;

  String _buildTitle() {
    return _activeMenu != 3
        ? _activeMenu != 2
              ? _activeMenu != 1
                    ? 'Resumo'
                    : 'Transações'
              : 'Orçamentos'
        : 'Evolução';
  }

  Widget _buildTap() {
    return _activeMenu != 3
        ? _activeMenu != 2
              ? _activeMenu != 1
                    ? Center(child: Text('dashboard'))
                    : Center(child: Text('transactions'))
              : Center(child: Text('budgets'))
        : Center(child: Text('reports'));
  }

  void _onChangeMenu(int index) {
    setState(() {
      _activeMenu = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_buildTitle()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(LucideIcons.settings),
          ),
        ],
        actionsPadding: const EdgeInsets.all(8.0),
      ),
      bottomNavigationBar: MyCustomBottomAppBar(
        activeIndex: _activeMenu,
        onDestinationSelected: _onChangeMenu,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(
          LucideIcons.circlePlus,
          color: Colors.white,
          size: 35.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(child: _buildTap()),
    );
  }
}
