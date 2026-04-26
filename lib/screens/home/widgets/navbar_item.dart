import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int activeIndex;
  final Function(int) onDestinationSelected;

  const NavBarItem({
    required this.activeIndex,
    required this.onDestinationSelected,
    required this.icon,
    required this.index,
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
