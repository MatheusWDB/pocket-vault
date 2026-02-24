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

  Widget _buildItem(IconData icon, int index) {
    final isSelected = activeIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey),
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
              _buildItem(LucideIcons.layoutDashboard, 0),
              _buildItem(LucideIcons.receiptText, 1),
            ],
          ),

          Row(
            spacing: 20.0,
            children: [
              _buildItem(LucideIcons.target, 2),
              _buildItem(LucideIcons.chartPie, 3),
            ],
          ),
        ],
      ),
    );
  }
}
