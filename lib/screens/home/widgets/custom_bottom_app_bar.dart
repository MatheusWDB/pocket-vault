import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MyCustomBottomAppBar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onDestinationSelected;

  const MyCustomBottomAppBar({
    required this.activeIndex,
    required this.onDestinationSelected,
    super.key,
  });

  Widget _buildItem(IconData icon, int index, context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final isSelected = activeIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? theme.selectedItemColor : theme.unselectedItemColor,
      ),
      onPressed: () => onDestinationSelected(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 40.0,
        children: [
          Row(
            spacing: 20.0,
            children: [
              _buildItem(LucideIcons.layoutDashboard, 0, context),
              _buildItem(LucideIcons.receiptText, 1, context),
            ],
          ),

          Row(
            spacing: 20.0,
            children: [
              _buildItem(LucideIcons.target, 2, context),
              _buildItem(LucideIcons.chartPie, 3, context),
            ],
          ),
        ],
      ),
    );
  }
}
