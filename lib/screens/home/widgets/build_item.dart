import 'package:flutter/material.dart';

class BuildItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final BuildContext context;
  final int activeIndex;
  final Function(int) onDestinationSelected;

  const BuildItem({
    required this.activeIndex,
    required this.onDestinationSelected,
    required this.icon,
    required this.index,
    required this.context,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
